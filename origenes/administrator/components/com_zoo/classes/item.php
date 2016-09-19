<?php
/**
* @package   ZOO Component
* @file      item.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
	Class: Item
		Item related attributes and functions.
*/
class Item extends YObject {

    /*
       Variable: id
         Primary key.
    */
	public $id;

    /*
       Variable: application_id
         Related application id.
    */
	public $application_id;

    /*
       Variable: type
         Item type.
    */
	public $type;

    /*
       Variable: name
         Item name.
    */
	public $name;

    /*
		Variable: alias
			Item alias.
    */
	public $alias;
	
    /*
       Variable: created
         Creation date.
    */
	public $created;

    /*
       Variable: modified
         Modified date.
    */
	public $modified;

    /*
       Variable: modified_by
         Modified by user.
    */
	public $modified_by;

    /*
       Variable: publish_up
         Publish up date.
    */
	public $publish_up;

    /*
       Variable: publish_down
         Publish down date.
    */
	public $publish_down;

    /*
       Variable: priority
         Item priority.
    */
	public $priority = 0;

    /*
       Variable: hits
         Hit count.
    */
	public $hits = 0;

    /*
       Variable: state
         Item published state.
    */
	public $state = 0;

    /*
       Variable: searchable
         Item searchable.
    */
	public $searchable = 1;

    /*
       Variable: access
         Item access level.
    */
	public $access;

    /*
       Variable: created_by
         Item created by user.
    */
	public $created_by;

    /*
       Variable: created_by_alias
         Item created by alias.
    */
	public $created_by_alias;

    /*
       Variable: params
         Item params.
    */
	public $params;
	
    /*
       Variable: elements
         Item elements.
    */
	public $elements;

    /*
       Variable: _params
         YParameter object.
    */
	protected $_params;
			
    /*
       Variable: _type
         Related type object.
    */
	protected $_type;

    /*
       Variable: elements
         Element objects.
    */
	protected $_elements;

    /*
       Variable: tags
         Tag objects.
    */
	protected $_tags;	

	/*
		Function: getApplication
			Get related application object.

		Returns:
			Application - application object
	*/
	public function getApplication() {
		return YTable::getInstance('application')->get($this->application_id);
	}
	
	/*
		Function: getType
			Get related type object.

		Returns:
			Type - type object
	*/
	public function getType() {

		if (empty($this->_type)) {
			$this->_type = $this->getApplication()->getType($this->type);
		}

		return $this->_type;
	}

	/*
		Function: getAuthor
			Get author name.

		Returns:
			String - author name
	*/
	public function getAuthor() {

		$author = $this->created_by_alias;

		if (!$author) {

			$user = JUser::getInstance($this->created_by);

			if ($user && $user->id) {
				$author = $user->name;
			}
		}

		return $author;
	}
	
	/*
    	Function: getState
    	  Get published state.

	   Returns:
	      -
 	*/
	public function getState() {
		return $this->state;
	}

	/*
    	Function: setState
    	  Set published state.

	   Returns:
	      -
 	*/
	public function setState($val) {
		$this->state = $val;
	}

	/*
    	Function: getSearchable
    	  Get published searchable.

	   Returns:
	      -
 	*/
	public function getSearchable() {
		return $this->searchable;
	}

	/*
    	Function: setSearchable
    	  Set published searchable.

	   Returns:
	      -
 	*/
	public function setSearchable($val) {
		$this->searchable = $val;
	}
		
	/*
    	Function: getElement
    	  Get element object by identifier.

	   	  Returns:
	        Object
 	*/
	public function getElement($identifier) {

		// load elements
		$elements = array_merge($this->getType()->getCoreElements($this), $this->getElements());
		
		if (isset($elements[$identifier])) {
			return $elements[$identifier];
		}
		
		return null;
	}

	/*
    	Function: getElements
    	  Get all element objects from the parsed type elements xml.

	   	  Returns:
	        Array - Array of element objects
 	*/
	public function getElements() {

		// get types elements
		if (empty($this->_elements)) {
			
			$this->_elements = $this->getType()->getElements($this);
			foreach ($this->_elements as $element) {
				$element->setData($this->elements);	
			}
		}

		return $this->_elements;
	}
	
	/*
		Function: getRelatedCategories
			Method to retrieve item's related categories.

		Parameters:
			$published - Only published categories

		Returns:
			Array - category id's
	*/
	public function getRelatedCategories($published = false) {
		return YTable::getInstance('category')->getByItemId($this->id, $published);
	}

	/*
		Function: getRelatedCategoryIds
			Method to retrieve item's related category id's.

		Returns:
			Array - category id's
	*/
	public function getRelatedCategoryIds($published = false) {
		return CategoryHelper::getItemsRelatedCategoryIds($this->id, $published);
	}

	/*
		Function: getParams
			Gets item params.

		Parameters:
  			$for - Get params for a specific use, including overidden values.

		Returns:
			Object - JParameter
	*/
	public function getParams($for = null) {
		
		// get params
		if (empty($this->_params)) {
			$this->_params = new YParameter();
			$this->_params->loadString($this->params);
		}

		// get site params and inherit globals
		if ($for == 'site') {			

			$site_params = new YParameter();
			$site_params->set('config.', $this->getApplication()->getParams()->get('global.config.'));
			$site_params->set('template.', $this->getApplication()->getParams()->get('global.template.'));
			$site_params->loadArray($this->_params->toArray());
			
			return $site_params;
		}

		return $this->_params;
	}

	/*
		Function: getTags
			Gets item related tags.

		Returns:
			Object - array with tags
	*/
	public function getTags() {

		if ($this->_tags === null) {
			$this->_tags = YTable::getInstance('tag')->getItemTags($this->id);
		}

		return $this->_tags;
	}
	
	/*
    	Function: setTags
    	  Bind tag array to object.

	   Returns:
	      Void
 	*/
	public function setTags($tags = array()) {
		
		$this->_tags = array_filter($tags);
		
		return $this;
	}	
	
	/*
    	Function: canAccess
    	  Check if item is accessible with users access rights.

	   Returns:
	      Boolean - True, if access granted
 	*/
	public function canAccess($user) {
		return $user->get('aid', 0) >= $this->access;
	}

	/*
		Function: hit
			Method to increment the hit counter

		Returns:
			Boolean - true on success
	*/
	public function hit() {
		return YTable::getInstance('item')->hit($this);
	}
	
	/*
		Function: getCommentsCount
			Get items comment count.

		Parameters:
  			$state - Specifiy the comments state to count

		Returns:
			int - Number of comments
	*/	
	public function getCommentsCount($state = 1) {
		return YTable::getInstance('comment')->count(array('conditions' => array('state = ? AND item_id = ?', $state, $this->id)));
	}
	
	/*
    	Function: isCommentsEnabled
    	  Checks wether comments are activated, globally and item specific.

	   Returns:
	      Boolean.
 	*/
	public function isCommentsEnabled() {
		return $this->getParams()->get('config.enable_comments', 1);
	}

}

/*
	Class: ItemException
*/
class ItemException extends YException {}