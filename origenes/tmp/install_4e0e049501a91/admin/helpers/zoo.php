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

/*
	Class: ZooHelper
		The general helper Class for zoo
*/
class ZooHelper {

	/*
		Function: toolbarHelp
			Add help button to current toolbar to show help url in popup window.

	   Parameters:
	      $ref - Help url

	   Returns:
	      Void
	*/
	public static function toolbarHelp($ref = 'http://zoo.yootheme.com/documentation') {
		$toolbar = JToolBar::getInstance('toolbar');
		$toolbar->appendButton('ZooHelp', $ref);
	}

	/*
		Function: resizeImage
			Resize and cache image file.

		Returns:
			String - image path
	*/
	public static function resizeImage($file, $width, $height) {

		// init vars
		$width      = (int) $width;
		$height     = (int) $height;
		$thumbfile  = JPATH_ROOT.'/cache/com_zoo/images/'.md5($file.$width.$height).'.'.YFile::getExtension($file);
		$cache_time = 86400; // cache time 24h

		// check thumbnail directory
		if (!JFolder::exists(dirname($thumbfile))) {
			JFolder::create(dirname($thumbfile));
		}

		// create or re-cache thumbnail
		if (YImageThumbnail::check() && (!is_file($thumbfile) || ($cache_time > 0 && time() > (filemtime($thumbfile) + $cache_time)))) {
			$thumbnail = new YImageThumbnail($file);

			if ($width > 0 && $height > 0) {
				$thumbnail->setSize($width, $height);
				$thumbnail->save($thumbfile);
			} else if ($width > 0 && $height == 0) {
				$thumbnail->sizeWidth($width);
				$thumbnail->save($thumbfile);
			} else if ($width == 0 && $height > 0) {
				$thumbnail->sizeHeight($height);
				$thumbnail->save($thumbfile);
			}
		}
		
		if (is_file($thumbfile)) {
			return $thumbfile;
		}
		
		return $file;
	}		
	
	/*
		Function: triggerContentPlugins
			Trigger joomla content plugins on given text.

	   Parameters:
            $text - Text

		Returns:
			String - Text
	*/
	public static function triggerContentPlugins($text) {

		// import joomla content plugins
		JPluginHelper::importPlugin('content');

		$params        = new JParameter('');
		$dispatcher    = JDispatcher::getInstance();
		$article       = JTable::getInstance('content');
		$article->text = $text;

		$dispatcher->trigger('onPrepareContent', array(&$article, &$params, 0));
		
		return $article->text;
	}
	
}

/*
   Class: JHTMLZoo
   	  A class that contains zoo html functions
*/
class JHTMLZoo {

	/*
    	Function: image
    	  Get image resource info. 

	   Returns:
	      Array - Image info
 	*/
	function image($image, $width = null, $height = null) {

		$resized_image = ZooHelper::resizeImage(JPATH_ROOT.DS.$image, $width, $height);
		$inner_path    = trim(str_replace('\\', '/', str_replace(JPATH_ROOT, '', $resized_image)), '/');
		$path 		   = JPATH_ROOT.'/'.$inner_path;
		
		if (is_file($path) && $size = getimagesize($path)) {

			$info['path'] 	= $path;
			$info['src'] 	= JURI::root().$inner_path;
			$info['mime'] 	= $size['mime'];
			$info['width'] 	= $size[0];
			$info['height'] = $size[1];
			$info['width_height'] = sprintf('width="%d" height="%d"', $info['width'], $info['height']);
		
			return $info;
		}

		return null;
	}

	/*
		Function: categoryList
			Returns category select list html string.
	*/
	function categoryList($application, $options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = NULL, $idtag = false, $translate = false) {
		
		// set options
		if (is_array($options)) {
			reset($options);
		} else {
			$options = array($options);
		}

		// get category tree list
		$tree = CategoryHelper::buildTree($application->id, $application->getCategories());
		$list = CategoryHelper::buildTreeList(0, $tree, array(), '-&nbsp;', '.&nbsp;&nbsp;&nbsp;', '&nbsp;&nbsp;');

		// create options
		foreach ($list as $category) {
			$options[] = JHTML::_('select.option', $category->id, $category->treename);
		}

		return JHTML::_('select.genericlist', $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);

	}

 	/*
    	Function: typeList
    		Returns type select list html string.
 	*/
	function typeList($options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = null, $idtag = false, $translate = false, $filter = array()) {
		
		if (is_array($options)) {
			reset($options);
		} else {
			$options = array($options);
		}

		foreach (Zoo::getApplication()->getTypes() as $type) {
			if (empty($filter) || in_array($type->id, $filter)) {
				$options[] = JHTML::_('select.option', $type->id, JText::_($type->name));
			}
		}
		
		return JHTML::_('select.genericlist', $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);			
	}

 	/*
    	Function: itemAuthorList
    		Returns author select list html string.
 	*/
	function itemAuthorList($options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = null, $idtag = false, $translate = false) {
		$query = 'SELECT i.created_by AS value, u.name AS text'
			    .' FROM '.ZOO_TABLE_ITEM.' AS i'
			    .' JOIN #__users AS u ON i.created_by = u.id'
			    .' GROUP BY i.created_by';
			
		return self::queryList($query, $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);		
	}

 	/*
    	Function: itemList
    		Returns item select list html string.
 	*/
	function itemList($application, $options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = null, $idtag = false, $translate = false) {
		$query = 'SELECT DISTINCT c.item_id as value, a.name as text'
			   	.' FROM '.ZOO_TABLE_COMMENT.' AS c'
			   	.' LEFT JOIN '.ZOO_TABLE_ITEM. ' AS a ON c.item_id = a.id'
			   	.' WHERE a.application_id = ' . $application->id
			   	.' ORDER BY a.name';

		if (is_array($options)) {
			reset($options);
		} else {
			$options = array($options);
		}
	
		$db = YDatabase::getInstance();
		$rows = $db->queryAssocList($query);
		
		foreach ($rows as $row) {
			$options[] = JHTML::_('select.option', $row['value'], $row['text']);
		}

		return JHTML::_('select.genericlist', $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);		
	}

 	/*
    	Function: itemAuthorList
    		Returns author select list html string.
 	*/
	function commentAuthorList($application, $options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = null, $idtag = false, $translate = false) {
		$query = "SELECT DISTINCT c.author AS value, c.author AS text"
			    ." FROM ".ZOO_TABLE_COMMENT." AS c"
			    .' LEFT JOIN '.ZOO_TABLE_ITEM. ' AS a ON c.item_id = a.id'
				." WHERE c.author <> ''"
				." AND a.application_id = " . $application->id
				." ORDER BY c.author";
		return self::queryList($query, $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);		
	}
	
 	/*
    	Function: queryList
			Returns select list html string.
 	*/
	function queryList($query, $options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = null, $idtag = false, $translate = false) {

		if (is_array($options)) {
			reset($options);
		} else {
			$options = array($options);
		}

		$db = YDatabase::getInstance();
		$list = $db->queryObjectList($query);
		
		$options = array_merge($options, $list);
		return JHTML::_('select.genericlist', $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);		
	}	

 	/*
    	Function: arrayList
			Returns select list html string.
 	*/
	function arrayList($array, $options, $name, $attribs = null, $key = 'value', $text = 'text', $selected = null, $idtag = false, $translate = false) {

		if (is_array($options)) {
			reset($options);
		} else {
			$options = array($options);
		}

		$options = array_merge($options, JHTMLZoo::listOptions($array));
		return JHTML::_('select.genericlist', $options, $name, $attribs, $key, $text, $selected, $idtag, $translate);		
	}	

 	/*
    	Function: selectOptions
    		Returns select option as JHTML compatible array.
 	*/
	function listOptions($array, $value = 'value', $text = 'text') {
		
		$options = array();
		
		if (is_array($array)) {
			foreach ($array as $val => $txt) {
				$options[] = JHTML::_('select.option', strval($val), $txt, $value, $text);
			}
		}

		return $options;
	}

}