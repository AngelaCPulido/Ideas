<?php
/**
* @package   ZOO Component
* @file      router.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// load config
require_once(JPATH_ADMINISTRATOR.'/components/com_zoo/config.php');

function ZooBuildRoute(&$query) {

	// init vars
	$segments = array();

	// frontpage
	$task = 'frontpage';

		if (@$query['task'] == $task || @$query['view'] == $task) {
			$segments[] = $task;
			unset($query['task']);
			unset($query['view']);

			// pagination
			if (isset($query['page'])) {
				$segments[] = $query['page'];
				unset($query['page']);
			}
		}

	// category
	$task = 'category';

		if ((@$query['task'] == $task || @$query['view'] == $task) && isset($query['category_id'])) {
			$segments[] = $task;
			$segments[] = CategoryHelper::translateIDToAlias((int) $query['category_id']);		
			unset($query['task']);
			unset($query['view']);
			unset($query['category_id']);

			// pagination
			if (isset($query['page'])) {
				$segments[] = $query['page'];
				unset($query['page']);
			}
		}

	// alpha index
	$task = 'alphaindex';

		if ((@$query['task'] == $task || @$query['view'] == $task) && isset($query['alpha_char'])) {
			$segments[] = $task;
			$segments[] = $query['alpha_char'];
			unset($query['task']);
			unset($query['view']);
			unset($query['alpha_char']);

			// pagination
			if (isset($query['page'])) {
				$segments[] = $query['page'];
				unset($query['page']);
			}
		}

	// tag
	$task = 'tag';

		if ((@$query['task'] == $task || @$query['view'] == $task) && isset($query['tag'])) {
			$segments[] = $task;
			$segments[] = $query['tag'];
			unset($query['task']);
			unset($query['view']);
			unset($query['tag']);

			// pagination
			if (isset($query['page'])) {
				$segments[] = $query['page'];
				unset($query['page']);
			}
		}

	// item
	$task = 'item';

		if ((@$query['task'] == $task || @$query['view'] == $task) && isset($query['item_id'])) {
			$segments[] = $task;
			$segments[] = ItemHelper::translateIDToAlias((int) $query['item_id']);		
			unset($query['task']);
			unset($query['view']);
			unset($query['item_id']);
		}

	// feed
	$task = 'feed';

		if ((@$query['task'] == $task || @$query['view'] == $task) && isset($query['type']) && isset($query['category_id'])) {
			$segments[] = $task;
			$segments[] = $query['type'];
			$segments[] = CategoryHelper::translateIDToAlias((int) $query['category_id']);		
			unset($query['task']);
			unset($query['view']);
			unset($query['type']);
			unset($query['category_id']);
		}

	return $segments;
}

function ZooParseRoute($segments) {
		
	// init vars
	$vars  = array();
	$count = count($segments);

	// fix segments (see JRouter::_decodeSegments)
	foreach (array_keys($segments) as $key) {
		$segments[$key] = str_replace(':', '-', $segments[$key]);
	}

	// frontpage (with optional pagination)
	$task = 'frontpage';

		if ($count == 1 && $segments[0] == $task) {
			$vars['task'] = $task;
		}

		if ($count == 2 && $segments[0] == $task) {
			$vars['task'] = $task;
			$vars['page'] = (int) $segments[1];			
		}

	// category (with optional pagination)
	$task = 'category';

		if ($count == 2 && $segments[0] == $task) {
			$vars['task']        = $task;
			$vars['category_id'] = (int) CategoryHelper::translateAliasToID($segments[1]);			
		}

		if ($count == 3 && $segments[0] == $task) {
			$vars['task']        = $task;
			$vars['category_id'] = (int) CategoryHelper::translateAliasToID($segments[1]);			
			$vars['page']        = (int) $segments[2];			
		}

	// alpha index (with optional pagination)
	$task = 'alphaindex';

		if ($count == 2 && $segments[0] == $task) {
			$vars['task']       = $task;
			$vars['alpha_char'] = (string) $segments[1];			
		}

		if ($count == 3 && $segments[0] == $task) {
			$vars['task']       = $task;
			$vars['alpha_char'] = (string) $segments[1];			
			$vars['page']       = (int) $segments[2];			
		}

	// tag (with optional pagination)
	$task = 'tag';

		if ($count == 2 && $segments[0] == $task) {
			$vars['task'] = $task;
			$vars['tag']  = (string) $segments[1];			
		}

		if ($count == 3 && $segments[0] == $task) {
			$vars['task'] = $task;
			$vars['tag']  = (string) $segments[1];			
			$vars['page'] = (int) $segments[2];			
		}

	// item
	$task = 'item';

		if ($count == 2 && $segments[0] == $task) {
			$vars['task']    = $task;
			$vars['item_id'] = (int) ItemHelper::translateAliasToID($segments[1]);			
		}

	// feed
	$task = 'feed';

		if ($count == 2 && $segments[0] == $task) {
			$vars['task'] = $task;
			$vars['type'] = (string) $segments[1];			
		}

		if ($count == 3 && $segments[0] == $task) {
			$vars['task']        = $task;
			$vars['type']        = (string) $segments[1];			
			$vars['category_id'] = (int) CategoryHelper::translateAliasToID($segments[2]);			
		}
		
	return $vars;
}