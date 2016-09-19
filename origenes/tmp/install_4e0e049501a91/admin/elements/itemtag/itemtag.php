<?php
/**
* @package   ZOO Component
* @file      itemtag.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
	Class: ElementItemTag
		The item tag element class
*/
class ElementItemTag extends Element {

	/*
		Function: hasValue
			Checks if the element's value is set.

	   Parameters:
			$params - render parameter

		Returns:
			Boolean - true, on success
	*/
	public function hasValue($params = array()) {
		$tags = $this->_item->getTags();
		return !empty($tags);
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

		$url 	= 'index.php?option=com_zoo&item_id='.$this->_item->id.'&task=tag&tag=';
		$linked = isset($params['linked']) && $params['linked'];
		
		$values = array();
		foreach ($this->_item->getTags() as $tag) {
			$values[] = $linked ? '<a href="'.$url.$tag.'">'.$tag.'</a>' : $tag;
		}
		
		return ElementHelper::applySeparators($params['separated_by'], $values);		
	}

	/*
	   Function: edit
	       Renders the edit form field.

	   Returns:
	       String - html
	*/
	public function edit() {
		return null;
	}
	
}