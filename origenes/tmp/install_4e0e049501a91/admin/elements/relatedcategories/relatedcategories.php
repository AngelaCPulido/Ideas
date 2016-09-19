<?php
/**
* @package   ZOO Component
* @file      relatedcategories.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
   Class: ElementRelatedCategories
       The category element class
*/
class ElementRelatedCategories extends Element {
	
	/*
		Function: hasValue
			Checks if the element's value is set.

	   Parameters:
			$params - render parameter

		Returns:
			Boolean - true, on success
	*/	
	public function hasValue($params = array()) {
		$category = $this->_data->get('category', array());
		return !empty($category);
	}	
	
	/*
		Function: render
			Override. Renders the element.

	   Parameters:
            $params - render parameter

		Returns:
			String - html
	*/
	public function render($params = array()) {
	
		$category_ids = $this->_data->get('category', array());

		$url 	= 'index.php?option=com_zoo&task=category&category_id=';
	
		$categories = array();
		$table = YTable::getInstance('category');
		foreach ($category_ids as $category_id) {
			$categories[] = '<a href="'.$url.$category_id.'">'.$table->get($category_id)->name.'</a>';
		}
		
		return ElementHelper::applySeparators($params['separated_by'], $categories);
			
	}

	/*
	   Function: _edit
	       Renders the edit form field.
		   Must be overloaded by the child class.

	   Returns:
	       String - html
	*/	
	public function edit(){
		//init vars
		$multiselect = $this->_config->get('multiselect', array());
		$multiselect = ($multiselect) ? ' multiple="multiple"' : '';

		return JHTML::_('zoo.categorylist', Zoo::getApplication(), array(), 'elements[' . $this->identifier . '][category][]', 'size="5"' . $multiselect, 'value', 'text', $this->_data->get('category', array()));
	}

}

class ElementRelatedCategoriesData extends ElementData{
	
	public function encodeData() {		
		$xml = YXMLElement::create($this->_element->getElementType())->addAttribute('identifier', $this->_element->identifier);
		foreach($this->_params->get('category', array()) as $category) {
			$xml->addChild('category')->setData($category);
		}

		return $xml;			
	}

	public function decodeXML(YXMLElement $element_xml) {
		$data = array();
		if (isset($element_xml->category)) {
			$categories = array();
			foreach ($element_xml->category as $category) {
				$categories[] = (string) $category;
			}
			$this->set('category', $categories);
		}
		return $data;
	}	
	
}