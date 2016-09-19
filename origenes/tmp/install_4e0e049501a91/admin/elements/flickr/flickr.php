<?php
/**
* @package   ZOO Component
* @file      flickr.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
   Class: ElementFlickr
       The Flickr element class (http://www.flickr.com)
*/
class ElementFlickr extends Element {

	/*
		Function: render
			Override. Renders the element.

	   Parameters:
            $params - render parameter

		Returns:
			String - html
	*/
	public function render() {

		// init vars
		$height   = $this->_config->get('height');
		$width 	  = $this->_config->get('width');		
		$tags     = $this->_data->get('value');
		$flickrid = $this->_data->get('flickrid', '');		

		// render html
		if ($width && $height && ($tags || $flickrid)) {

			$vars = array();
			
			if ($flickrid) {
				$vars[] = 'user_id='.$flickrid;
			}
			
			if ($tags) {
				$vars[] = 'tags='.$tags;
			}
		
			$html  = '<iframe src="http://www.flickr.com/slideShow/index.gne?'.implode('&', $vars). '"';
			$html .= ' align="middle" frameborder="0" height="'. $height .'"';
			$html .= ' scrolling="no" width="'. $width .'"';
			$html .= '></iframe>'	;
			
			return $html;
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
		$html .= JHTML::_('element.editrow', JText::_('Tags'), JHTML::_('control.text', 'elements[' . $this->identifier . '][value]', $this->_data->get('value'), 'maxlength="255"'));
		$html .= JHTML::_('element.editrow', JText::_('Flickr ID'), JHTML::_('control.text', 'elements[' . $this->identifier . '][flickrid]', $this->_data->get('flickrid', ''), 'maxlength="255"'));
		$html .= '</table>';
		
		return $html;
	}

}