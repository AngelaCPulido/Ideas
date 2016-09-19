<?php
/**
* @package   ZOO Category Module
* @file      mod_zoocategory.php
* @version   2.0.0 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// load config
require_once(JPATH_ADMINISTRATOR.'/components/com_zoo/config.php');

$app = YTable::getInstance('application')->get($params->get('application', 0));

// is application ?
if (empty($app)) {
	return null;
}	

// set one or multiple categories
$categories = array();
$all_categories = $app->getCategoryTree(true);
if (isset($all_categories[$params->get('category', 0)])) {
	$categories = $all_categories[$params->get('category', 0)]->getChildren();
}

if (count($categories)) {

	$menu_item = $params->get('menu_item');
	$itemid    = $menu_item ? '&Itemid='.$menu_item : '';
	$url = 'index.php?option=com_zoo&task=category'.$itemid.'&category_id=';
	
	$max_depth = $params->get('depth', 0);

	include(JModuleHelper::getLayoutPath('mod_zoocategory', $params->get('theme', 'default')));
	
}
