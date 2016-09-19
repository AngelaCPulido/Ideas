<?php
/**
* @package   ZOO Component
* @file      string.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

class YString extends JString {
	
	/*
		Function: truncate
			Truncates the input string.

		Parameters:
			$text - input string
			$length - the length of the output string
			$truncate_string - the truncate string			

		Returns:
			String - truncated string
	*/	
	public static function truncate($text, $length = 30, $truncate_string = '...') {
	
		if ($text == '') {
			return '';
		}

		if (self::strlen($text) > $length) {
			$length -= min($length, strlen($truncate_string));
			$text  = preg_replace('/\s+?(\S+)?$/', '', substr($text, 0, $length + 1));

			return self::substr($text, 0, $length) . $truncate_string;

		} else {
			return $text;
		} 
	}
	
	/*
		Function: sluggify
			Sluggifies the input string.

		Parameters:
			$string - input string

		Returns:
			String - sluggified string
	*/	
	public static function sluggify($string) {

		$string = preg_replace(array('/\s+/','/[^\x{00C0}-\x{00D6}x{00D8}-\x{00F6}x{00F8}-\x{00FF}x{0370}-\x{1FFF}a-z0-9\-]/ui'), array('-',''), $string);

		return trim(mb_strtolower($string));
		
	}

}