<?php
/**
* @package   ZOO Tag Module
* @file      mod_zootag.php
* @version   2.0.0 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// load config
require_once(JPATH_ADMINISTRATOR.'/components/com_zoo/config.php');

// load helper
require_once(dirname(__FILE__).DS.'helper.php');

// init vars
$app = YTable::getInstance('application')->get($params->get('application', 0));

// is application ?
if (empty($app)) {
	return null;
}		

// get tags
$tags = modZooTagHelper::buildTagCloud($app, $params);

// load template
include(JModuleHelper::getLayoutPath('mod_zootag', $params->get('theme', 'list')));