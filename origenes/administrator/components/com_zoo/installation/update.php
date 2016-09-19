<?php
/**
* @package   ZOO Component
* @file      update.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// BETA2 -> BETA3
$db = YDatabase::getInstance();
$fields = $db->getTableFields(ZOO_TABLE_APPLICATION);
if (isset($fields[ZOO_TABLE_APPLICATION]) && !array_key_exists('application_group', $fields[ZOO_TABLE_APPLICATION])) {
	$db->query('ALTER TABLE '.ZOO_TABLE_APPLICATION.' ADD application_group VARCHAR(255) AFTER name');	
}

// UPGRADE ZOO BETA2 -> ZOO BETA3
$app_table = YTable::getInstance('application');
$apps = $app_table->all();
if (!empty($apps)) {
	foreach ($apps as $app) {
		if (empty($app->application_group)) {
			$app->application_group = $app->getParams()->get('group');
			$app_table->save($app);
		}
	}
}