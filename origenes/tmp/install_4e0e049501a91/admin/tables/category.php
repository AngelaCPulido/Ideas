<?php
/**
* @package   ZOO Component
* @file      category.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
	Class: CategoryTable
		The table class for categories.
*/
class CategoryTable extends YTable {

	protected function __construct() {
		parent::__construct('Category', ZOO_TABLE_CATEGORY, 'id');
	}

	/*
		Function: save
			Override. Save object to database table.

		Returns:
			Boolean.
	*/
	public function save($object) {

		if ($object->name == '') {
			throw new CategoryTableException('Invalid name');
		}

		if ($object->alias == '' || preg_match('/[^A-Za-z0-9_-]/', $object->alias)) {
			throw new CategoryTableException('Invalid slug');
		}
		
		if (CategoryHelper::checkAliasExists($object->alias, $object->id)) {
			throw new CategoryTableException('Slug already exists, please choose a unique slug');
		}		
		
		if (!is_numeric($object->parent)) {
			throw new CategoryTableException('Invalid parent id');
		}

		return parent::save($object);
	}

	/*
		Function: delete
			Override. Delete object from database table.

		Returns:
			Boolean.
	*/
	public function delete($object) {

		// get database
		$db = $this->getDBO();
		
		// update childrens parent category
		$query = "UPDATE ".$this->getTableName()
		    	." SET parent=".$object->parent
			    ." WHERE parent=".$object->id;
		$db->query($query);

		// delete category to item relations
		CategoryHelper::deleteCategoryItemRelations($object->id);

		return parent::delete($object);
	}
	
	/*
		Function: getbyId
			Method to retrieve categories by id.

		Parameters:
			$category_id - Categorie id(s)

		Returns:
			Array - Array of categories
	*/
	public function getById($category_id){
		$query = "SELECT *"
			    ." FROM ".$this->getTableName()
			    ." WHERE ".(is_array($category_id) ? "id IN (".implode(",", $category_id).")" : "id = ".(int) $category_id);

		return $this->_queryObjectList($query, $this->getKeyName());
	}

	/*
		Function: getAll
			Method to retrieve all categories of a application.

		Parameters:
			$application_id - Application Id
			$published - Only published categories

		Returns:
			Array - Array of categories
	*/
	public function getAll($application_id, $published = false){
		
		$where = 'application_id = ?' . ($published == true ? " AND published = 1" : "");
		return $this->all(array('conditions' => array($where, $application_id), 'order' => 'ordering'));

	}
	
	/*
		Function: getByItemId
			Method to retrieve item's related categories.

		Parameters:
			$item_id - Item id
			$published - Only published categories

		Returns:
			Array - Related categories
	*/
	public function getByItemId($item_id, $published = false) {
		$query = 'SELECT b.*'
	            .' FROM '.ZOO_TABLE_CATEGORY_ITEM.' AS a'
	            .' JOIN '.$this->getTableName().' AS b ON b.id = a.category_id'
			    .' WHERE a.item_id='.(int) $item_id
			    .($published == true ? " AND b.published = 1" : "");

		return $this->_queryObjectList($query, $this->getKeyName());
	}

	/*
		Function: count
			Method to retrieve count categories of an application.

		Parameters:
			$application_id - Application id

		Returns:
			Int
	*/
	public function count($application_id){
		$query = "SELECT COUNT(*)"
			." FROM ".$this->getTableName()
			." WHERE application_id = ".(int) $application_id;

		return (int) $this->_queryResult($query);
	}
	
	/*
		Function: updateorder
			Method to check/fix category ordering.

		Parameters:
			$application_id - Application id
			$parents - Parent category id(s)

		Returns:
			Boolean. True on success
	*/
	public function updateorder($application_id, $parents = array()) {
		
		if (!is_array($parents)) {
			$parents = array($parents);
		}

		// execute update order for each parent categories
		$parents = array_unique($parents);
		foreach ($parents as $parent) {
			if (!$this->reorder('application_id = '.(int) $application_id.' AND parent = '.(int) $parent)) {
				return false;
			}
		}

		return true;
	}

	/*
		Function: reorder
			Compacts the ordering sequence of the selected records.

		Parameters:
			$where - SQL where condition

		Returns:
			Boolean. True on success
	*/
	public function reorder($where = '') {

		// get database
		$db = $this->getDBO();

		// get rows
		$query = 'SELECT '.$this->getKeyName().', ordering'
		        .' FROM '.$this->getTableName()
		        .($where ? ' WHERE '.$where : '')
		        .' ORDER BY ordering';
		$rows =	$db->queryObjectList($query, $this->getKeyName());

		// init vars
		$i      = 1;
		$update = array();

		// collect rows which ordering need to be updated
		foreach ($rows as $id => $row) {

			if ($row->ordering != $i) {
				$update[$i - $row->ordering][] = $id;
			}

			$i++;
		}
		
		// do the ordering update
		foreach ($update as $diff => $ids) {

			// build ordering update query
			$query = 'UPDATE '.$this->getTableName()
				    .sprintf(' SET ordering = (ordering'.($diff >= 0 ? '+' : '').'%s)', $diff)
				    .sprintf(' WHERE '.$this->getKeyName().(count($ids) == 1 ? ' = %s' : ' IN (%s)'), implode(',', $ids));

			// set and execute query
			$db->query($query);
		}

		return true;
	}	

}

/*
	Class: CategoryTableException
*/
class CategoryTableException extends YException {}