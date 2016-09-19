<?php
/**
* @package   ZOO Component
* @file      zoomodule.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

class ZooModuleHelper {

	public static function getItems(JParameter $params) {

		$items = array();
		if ($app = YTable::getInstance('application')->get($params->get('application', 0))) {

			// set one or multiple categories
			$category = $params->get('category', 0);
			if ($params->get('subcategories')) {
				$categories = $app->getCategoryTree(true);
				if (isset($categories[$category])) {
					$category = array_merge(array($category), array_keys($categories[$category]->getChildren(true)));
				}
			}
			
			// get items
			if ($params->get('mode') == 'item') {
				$items = self::getItem($params->get('item_id'));
			} else if ($params->get('mode') == 'types') {
				$items = self::getItemsByType($app, $params->get('type'), $params->get('order', 'date'), $params->get('count', 4));
			} else {
				$items = self::getItemsByCategory($app, $category, $params->get('order'), $params->get('count', 4));
			}
			
			// get Itemid
			$menu_item = $params->get('menu_item', 0);
			$itemid    = $menu_item ? '&Itemid='.$menu_item : '';
			
			// add link to item
			foreach ($items as $item) {
				$item->href = sprintf('index.php?option=com_zoo&task=item&item_id=%d%s', $item->id, $itemid);
			}
		}
		
		return $items;
	}
	
	public static function getItem($id) {

		// init vars
		$table = YTable::getInstance('item');
		$items = array();
	
		if ($item = $table->get((int) $id)) {
			$items[] = $item;
		}

		return $items;
	}
	
	public static function getItemsByCategory($app, $categories, $ordering, $limit) {

		// init vars
		$table = YTable::getInstance('item');
		$order = self::getOrder($ordering);

		return $table->getFromCategory($app->id, $categories, true, null, $order, 0, $limit);
	}

	public static function getItemsByType($app, $type, $ordering, $limit) {

		// init vars
		$table = YTable::getInstance('item');

		// get database
		$db = $table->getDBO();

		// get user from session, if not set
		if (empty($user)) {
			$user = JFactory::getUser();
		}

		// get user access id
		$access_id = $user->get('aid', 0);

		// get date
		$date = JFactory::getDate();
		$now  = $db->Quote($date->toMySQL());
		$null = $db->Quote($db->getNullDate());
		
		// set query options
		$conditions = 
		     "a.application_id = ".(int) $app->id
			." AND a.access <= ".(int) $access_id
			." AND a.state = 1"		
			." AND a.type = '?'"		
			." AND (a.publish_up = ".$null." OR a.publish_up <= ".$now.")"
			." AND (a.publish_down = ".$null." OR a.publish_down >= ".$now.")";

		$options = array(
			'select' => 'a.*',
			'from' => ZOO_TABLE_ITEM.' AS a',
			'conditions' => array($conditions, $type),
			'order' => self::getOrder($ordering),
			'limit' => $limit);

		return $table->all($options);
	}
	
	public static function getOrder($order) {

		$orders = array(
			'date'   => 'a.created ASC',
			'rdate'  => 'a.created DESC',
			'alpha'  => 'a.name ASC',
			'ralpha' => 'a.name DESC',
			'hits'   => 'a.hits DESC',
			'rhits'  => 'a.hits ASC',
			'random' => 'RAND()');

		return isset($orders[$order]) ? $orders[$order] : '';
	}
}
