<?php
/**
* @package   ZOO Component
* @file      link.php
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
   Class: ElementLink
       The link element class
*/
class ElementLink extends ElementRepeatable {

	/*
		Function: _hasValue
			Checks if the repeatables element's value is set.

	   Parameters:
			$params - render parameter

		Returns:
			Boolean - true, on success
	*/	
	protected function _hasValue($params) {
		$link = $this->_data->get('value', '');
		$text = $this->getText();
		return !empty($link) && !empty($text);		
	}

	
	/*
		Function: getText
			Gets the link text.

		Returns:
			String - text
	*/
	public function getText() {
		
		// init vars
		$use_link_as_text = $this->_config->get('use_link_as_text');
		$default_text = $this->_config->get('default_text');			
		
		if ($use_link_as_text) {
			return $this->_data->get('value', '');
		} else if (!empty($default_text)) {
			return $default_text;
		} else {
			return $this->_data->get('text', '');
		}
	}

	/*
		Function: getRel
			Gets the link rel.

		Returns:
			String - rel
	*/
	public function getRel() {
		
		// init vars
		$default_rel = $this->_config->get('default_rel');
				
		if (empty($default_rel)) {
			return $this->_data->get('rel', '');
		} else {
			return $default_rel;
		}
	}
	
	/*
		Function: getTitle
			Gets the link title.

		Returns:
			String - title
	*/
	public function getTitle() {

		// init vars
		$custom_title = $this->_config->get('custom_title');
		
		if ($custom_title) {
			return $this->_data->get('custom_title', '');
		} else {
			return $this->getText();
		}
	}
	
	/*
		Function: render
			Renders the repeatable element.

	   Parameters:
            $params - render parameter

		Returns:
			String - html
	*/
	protected function _render($params = array()) {

		$target = ($this->_data->get('target', '')) ? 'target="_blank"' : '';
		$rel	= ($this->getRel()) ? 'rel="' . $this->getRel() .'"' : '';
					
		return '<a href="'.JRoute::_($this->_data->get('value', '')).'" title="'.$this->getTitle().'" '.$target.' '. $rel .'>'.$this->getText().'</a>';

	}

	/*
	   Function: _edit
	       Renders the repeatable edit form field.

	   Returns:
	       String - html
	*/		
	protected function _edit(){
		
		// init vars
		$use_link_as_text 	= $this->_config->get('use_link_as_text');
		$default_text 		= $this->_config->get('default_text');
		$custom_title 		= $this->_config->get('custom_title');
		$default_rel 		= $this->_config->get('default_rel');
				
		// create html
		$html  = '<table>';
		
		// link text
		if (!$use_link_as_text && empty($default_text)) {
			$html .= JHTML::_('element.editrow', JText::_('Text'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][text]', $this->getText(), 'size="60" maxlength="255"'));
		}
		
		// link
		$html .= JHTML::_('element.editrow', JText::_('Link'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][value]', $this->_data->get('value', ''), 'size="60" maxlength="255"'));
		
		// target
		$html .= JHTML::_('element.editrow', JText::_('New window'), JHTML::_('select.booleanlist', 'elements[' . $this->identifier . ']['.$this->index().'][target]', $this->_data->get('target', ''), $this->_data->get('target', '')));

		// custom title
		if ($custom_title) {
			$html .= JHTML::_('element.editrow', JText::_('Title'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][custom_title]', $this->getTitle(), 'size="60" maxlength="255"'));
		}
		
		// rel
		if (empty($default_rel)) {
			$html .= JHTML::_('element.editrow', JText::_('Rel'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][rel]', $this->getRel(), 'size="60" maxlength="255"'));
		}
		
		$html .= '</table>';

		return $html;	
	}	
}