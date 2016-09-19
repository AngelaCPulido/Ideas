<?php
/**
* @package   ZOO Component
* @file      zoo.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// check php version
if (version_compare(PHP_VERSION, '5.2', '<')) {
	JError::raiseWarning(0, JText::_('ZOO_REQUIREMENTS'));
	return;	
}

// init zoo
require_once(dirname(__FILE__).'/init.php');