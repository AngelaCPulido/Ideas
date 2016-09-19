<?php
/**
* @package   ZOO Component
* @file      database.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
	Class: YDatabase
		The database class (wraps joomla database object), provides general functions to query the database.
*/
class YDatabase {

	protected $_dbo;
	protected static $_instance;

	protected function __construct() {
		$this->_dbo = JFactory::getDBO();
	}

	public static function getInstance() {
		
		if (!isset(self::$_instance)) {
			self::$_instance = new YDatabase();
		}

		return self::$_instance;
	}

	public function query($query) {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->query();
		
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}
	
		return $result;
	}

	public function queryResult($query) {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->loadResult();
	
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}

	public function queryObject($query) {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->loadObject();
	
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}

	public function queryObjectList($query, $key = '') {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->loadObjectList($key);
		
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}
	
	public function queryResultArray($query, $numinarray = 0) {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->loadResultArray($numinarray);
		
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}
	
	public function queryAssoc($query) {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->loadAssoc();
		
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}		
		
	public function queryAssocList($query, $key = '') {

		// query database table
		$this->_dbo->setQuery($query);
		$result = $this->_dbo->loadAssocList($key);
		
		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}		

	public function insertObject($table, $object, $key = null) {

		// insert object
		$result = $this->_dbo->insertObject($table, $object, $key);

		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}

	public function updateObject($table, $object, $key, $updatenulls = true) {

		// update object
		$result = $this->_dbo->updateObject($table, $object, $key, $updatenulls);

		// throw exception, on database error
		if ($this->_dbo->getErrorNum()) {
			throw new YDatabaseException(__METHOD__.' failed. ('.$this->_dbo->getErrorMsg().')');
		}

		return $result;
	}
	
    public function __call($method, $args) {
        return call_user_func_array(array($this->_dbo, $method), $args);
    }

}

/*
	Class: YDatabaseException
*/
class YDatabaseException extends YException {}