<?php
/**
* @package   ZOO Component
* @file      image.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

/*
	Class: ElementImage
		The image element class
*/
class ElementImage extends Element {

	/*
		Function: hasValue
			Checks if the element's value is set.

	   Parameters:
			$params - render parameter

		Returns:
			Boolean - true, on success
	*/
	public function hasValue($params = array()) {

		// init vars
		$file = $this->_data->get('file');
		
		return !empty($file);
	}
	
	/*
		Function: getSearchData
			Get elements search data.
					
		Returns:
			String - Search data
	*/
	public function getSearchData() {
		if ($this->_config->get('custom_title')) {
			return $this->_data->get('title');
		}		
		return null;
	}	
	
	/*
		Function: getTitle
			Gets the image title.

		Returns:
			String - title
	*/
	public function getTitle() {
		if ($this->_config->get('custom_title')) {
			return $this->_data->get('title');
		} else {
			return $this->getItem()->name;
		}
	}
	
	/*
		Function: getRel
			Gets the image link rel.

		Returns:
			String - rel
	*/
	public function getRel() {
		
		// init vars
		$default_rel = $this->_config->get('default_rel');
				
		if (empty($default_rel)) {
			return $this->_data->get('rel');
		} else {
			return $default_rel;
		}
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
		$title  	  = $this->getTitle();
		$params		  = new YArray($params);	
		$file  		  = ZooHelper::resizeImage(JPATH_ROOT.DS.$this->_data->get('file'), $params->get('width', 0), $params->get('height', 0));
		$link   	  = JURI::root() . trim(str_replace('\\', '/', str_replace(JPATH_ROOT, '', $file)), '/');

		if ($params->get('link_to_item', false)) {

			$menu_item = $params->get('menu_item');
			$itemid	   = $menu_item ? '&Itemid='.$menu_item : '';
			$url	   = 'index.php?option=com_zoo&task=item&item_id='.$this->getItem()->id.$itemid;
			$target	   = false;
			$rel  	   = '';
			$title 	   = $this->getItem()->name;
			
		} else if ($this->_data->get('link') && $this->_config->get('custom_link')) {
			
			$url 	= $this->_data->get('link');		
			$target	= $this->_data->get('target');
			$rel  	= $this->getRel();
		
		} else {
			
			$url = '';
			$target = '';
			$rel = '';	
					
		}
		
		// render layout
		if ($layout = $this->getLayout()) {
			return self::renderLayout($layout, array('file' => $file, 'title' => $title, 'link' => $link, 'link_enabled' => !empty($url), 'url' => $url, 'target' => $target, 'rel' => $rel));
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

		// get params
		$params = JComponentHelper::getParams('com_media');
		$img_ext = str_replace(',', '|', trim($params->get('image_extensions'), ','));

		// init vars
		$title  	  = htmlspecialchars(html_entity_decode($this->getTitle(), ENT_QUOTES), ENT_QUOTES);
		$custom_title = $this->_config->get('custom_title');
		$default_rel  = $this->_config->get('default_rel');
		$custom_link  = $this->_config->get('custom_link');
		
		// create html
		$html  = '<table>';
		$html .= JHTML::_('element.editrow', JText::_('File'), '<input class="image-select" type="text" name="elements['.$this->identifier.'][file]" value="'.$this->_data->get('file').'" style="width:200px;margin-right:5px;" />');
		
		// custom title
		if ($custom_title) {
		$html .= JHTML::_('element.editrow', JText::_('Title'), JHTML::_('control.text', 'elements['.$this->identifier.'][title]', $title, 'maxlength="255"'));
		}
		
		if ($custom_link) {
			$html .= JHTML::_('element.editrow', JText::_('Link'), JHTML::_('control.text', 'elements['.$this->identifier.'][link]', $this->_data->get('link'), 'size="60" maxlength="255"'));
			$html .= JHTML::_('element.editrow', JText::_('New window'), JHTML::_('select.booleanlist', 'elements['.$this->identifier.'][target]', $this->_data->get('target'), $this->_data->get('target')));
			// rel
			if (empty($default_rel)) {			
				$html .= JHTML::_('element.editrow', JText::_('Rel'), JHTML::_('control.text', 'elements['.$this->identifier.'][rel]', $this->getRel(), 'size="60" maxlength="255"'));
			}
		}
		$html .= '</table>';

		return $html;
	}
			
	/*
		Function: loadAssets
			Load elements css/js assets.

		Returns:
			Void
	*/
	public function loadAssets() {
		JHTML::script('image.js', 'administrator/components/com_zoo/assets/js/');
	}

}

class ElementImageData extends ElementData{

	public function encodeData() {

		// add image width/height
		$filepath = JPATH_ROOT.DS.$this->_params->get('file');

		if (JFile::exists($filepath)) {
			$size = getimagesize($filepath);
			$this->set('width', ($size ? $size[0] : 0));
			$this->set('height', ($size ? $size[1] : 0));
		}
		
		return parent::encodeData();			
	}		
	
}