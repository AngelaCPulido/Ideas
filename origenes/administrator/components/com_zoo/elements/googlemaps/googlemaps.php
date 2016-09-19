<?php
/**
* @package   ZOO Component
* @file      googlemaps.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// register maps helper classes
require_once(ZOO_ADMIN_PATH.'/elements/googlemaps/helper.php');

/*
	Class: ElementGooglemaps
		The google maps element class
*/
class ElementGooglemaps extends Element {
	
	/*
		Function: hasValue
			Checks if the element's value is set.

	   Parameters:
			$params - render parameter

		Returns:
			Boolean - true, on success
	*/
	public function hasValue($params = array()) {
		$value = $this->_data->get('location');
		return !empty($value);
	}
	
	/*
		Function: render
			Renders the element.

	   Parameters:
            $params - render parameter

		Returns:
			String - html
	*/
	public function render($params = array()) {

		// init vars
		$location          = $this->_data->get('location');
		$google_api_key    = $this->_config->get('google_api_key');
		$locale            = $this->_config->get('locale');

		// init display params
		$params            = new YArray($params);
		$layout_path 	   = $params->get('layout_path');
		$layout   		   = $params->get('layout');
		$width             = $params->get('width');
		$width_unit        = $params->get('width_unit');
		$height            = $params->get('height');
		$marker_popup      = $params->get('marker_popup');
		$zoom_level        = $params->get('zoom_level');
		$map_controls      = $params->get('map_controls');
		$scroll_wheel_zoom = $params->get('scroll_wheel_zoom');
		$map_type          = $params->get('map_type');
		$map_controls      = $params->get('map_controls');
		$type_controls     = $params->get('type_controls');
		$overview_controls = $params->get('overview_controls');
		$directions        = $params->get('directions');
		$main_icon         = $params->get('main_icon');
		$information       = $params->get('information');
		
		// get marker text
		$marker_text = '';
		$renderer = new ItemRenderer();
		$renderer->addPath($layout_path);
		if ($item = $this->getItem()) {
			$path   = 'item';
			$prefix = 'item.';
			$type   = $item->getType()->id;
			if ($renderer->pathExists($path.DIRECTORY_SEPARATOR.$type)) {
				$path   .= DIRECTORY_SEPARATOR.$type;
				$prefix .= $type.'.';
			}

			if (in_array($layout, $renderer->getLayouts($path))) {
				$marker_text = $renderer->render($prefix.$layout, array('item' => $item));
			} else {
				$marker_text = $item->name;
			}
		}
		
		// get geocode cache
		$cache = new YCache(ZOO_CACHE_PATH.DS.'geocode_cache.txt');
		if (!$cache->check()) { 
			return "<div class=\"alert\"><strong>Cache not writeable please update the file permissions! (geocode_cache.txt)</strong></div>\n";
		}
		
		// get map center coordinates
		$center = GooglemapsHelper::locate($google_api_key, $location, $cache);
		if (!$center) { 
			return "<div class=\"alert\"><strong>Unable to get map center coordinates, please verify your location! (".$location.")</strong></div>\n";
		}

		// save location to geocode cache
		if ($cache) $cache->save();
		
		// css parameters
		$maps_id           = 'googlemaps-'.$this->_item->id;
		$css_module_width  = 'width: '.$width.$width_unit.';';
		$css_module_height = 'height: '.$height.'px;';
		$from_address      = JText::_('From address:');
		$get_directions    = JText::_('Get directions');
		$empty             = JText::_('Please fill in your address.');
		$not_found         = JText::_('Sorry, address not found!');
		$address_not_found = ', ' . JText::_('not found!');
		
		// js parameters
		$maps_var    = 'map'.$this->_item->id;
		$javascript  = "var $maps_var = new Googlemaps('" . $maps_id . "', { lat:" . $center['lat'] . ", lng:" . $center['lng'] . ", popup: " . $marker_popup . ", text: '" . GooglemapsHelper::stripText($marker_text) . "', zoom: " . $zoom_level . ", mapCtrl: " . $map_controls . ", zoomWhl: " . $scroll_wheel_zoom . ", mapType: " . $map_type . ", typeCtrl: " . $type_controls . ", overviewCtrl: " . $overview_controls . ", directions: " . $directions . ", locale: '" . $locale . "', mainIcon:'" . $main_icon . "', msgFromAddress: '" . $from_address . "', msgGetDirections: '" . $get_directions . "', msgEmpty: '" . $empty . "', msgNotFound: '" . $not_found . "', msgAddressNotFound: '" . $address_not_found . "' });";
		$javascript = "window.addEvent('load', function() { ".$javascript." });";

		// render layout
		if ($layout = $this->getLayout()) {
			return self::renderLayout($layout, array('maps_id' => $maps_id, 'google_api_key' => $google_api_key, 'javascript' => $javascript, 'css_module_width' => $css_module_width, 'css_module_height' => $css_module_height, 'information' => $information));
		}
		
		return null;
	}
	
	/*
	   Function: edit
	       Renders the edit form field.

	   Returns:
	       String - html
	*/
	public function edit() {


		// create html
		$html  = '<table>';
		$html .= JHTML::_('element.editrow', JText::_('Location'), JHTML::_('control.text', 'elements['.$this->identifier.'][location]', $this->_data->get('location'), 'maxlength="255"'));
		$html .= '</table>';

		return $html;
	}

}