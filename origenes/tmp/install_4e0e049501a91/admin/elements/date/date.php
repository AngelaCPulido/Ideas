<?php
/**
* @package   ZOO Component
* @file      date.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// register yoo gallery class
JLoader::register('ElementRepeatable', ZOO_ADMIN_PATH.'/elements/repeatable/repeatable.php');

/*
   Class: ElementDate
   The date element class
*/
class ElementDate extends ElementRepeatable {
	
	/*
		Function: render
			Renders the repeatable element.

	   Parameters:
            $params - render parameter

		Returns:
			String - html
	*/
	protected function _render($params = array()) {
		
		return JHTML::_('date', $this->_data->get('value', ''), (($params['date_format'] == 'custom') ? $params['custom_format'] : $params['date_format']));

	}

	/*
	   Function: _edit
	       Renders the repeatable edit form field.

	   Returns:
	       String - html
	*/		
	protected function _edit(){
		
		// create html
		return JHTML::_('element.calendar', $this->_data->get('value', ''), 'elements[' . $this->identifier . ']['.$this->index().'][value]', 'elements[' . $this->identifier . ']['.$this->index().']value', '%Y-%m-%d %H:%M:%S', array('class' => 'calendar-element'));

	}
	


}