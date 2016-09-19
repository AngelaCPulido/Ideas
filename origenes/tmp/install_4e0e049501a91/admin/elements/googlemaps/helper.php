<?php
/**
* @package   ZOO Component
* @file      helper.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

class GooglemapsHelper {
	
	public static function stripText($text) {
		$text = str_replace(array("\r\n", "\n", "\r", "\t"), "", $text);
		$text = addcslashes($text, "'");
		return $text;
	}

	public static function locate($gapikey, $location, $cache = null) {
		// check if location are lng / lat values
		$location = trim($location);
		if (ereg('([0-9.-]{1,}),([0-9.-]{1,})', $location, $regs)) {
			if ($location == $regs[0]) {
				return array('lat' => $regs[1], 'lng' => $regs[2]);
			}
		}
		
		// use geocode to translate location
		return self::geoCode($gapikey, $location, $cache);
	}

	public static function geoCode($gapikey, $address, $cache = null) {
		// use cache result
		if ($cache !== null && $value = $cache->get($address)) {
			if (ereg('([0-9.-]{1,}),([0-9.-]{1,})', $value, $regs)) {
				return array('lat' => $regs[1], 'lng' => $regs[2]);
			}
		}
				
		// query google maps geocoder and parse result
		$result      = self::queryGeoCoder($gapikey, $address);
		$coordinates = null;
		if (ereg('<coordinates>([0-9.-]{1,}),([0-9.-]{1,}).*</coordinates>', $result, $regs)) {
		   $coordinates = array('lng' => $regs[1], 'lat' => $regs[2]);
		}
		
		// cache geocoder result
		if ($cache !== null && $coordinates !== null) {
			$cache->set($address, $coordinates['lat'].",".$coordinates['lng']);
		}

		return $coordinates;
	}

	public static function queryGeoCoder($gapikey, $address) {
	    $contents = '';

		// query use fsockopen
	    $fp = @fsockopen('maps.google.com', 80, $errno, $errstr, 30);
	    if ($fp !== false) {
			$out  = "GET /maps/geo?&output=xml&key=" . $gapikey . "&q=" . urlencode($address) . " HTTP/1.1\r\n";
			$out .= "Host: maps.google.com\r\n";
			$out .= "Connection: Close\r\n\r\n";
	        @fwrite($fp, $out);
	        while (!feof($fp)) {
	            $contents .= fgets($fp, 4096);
	        }
	        @fclose($fp);
			return $contents;
	    }

		// query use fopen
		if (ini_get('allow_url_fopen')) {
			$fp = @fopen('http://maps.google.com/maps/geo?&output=xml&key=' . $gapikey . '&q=' . urlencode($address), 'r');
			if ($fp !== false) {
				while (!feof($fp)) {
			        $contents .= fread($fp, 4096);
			    }
			    @fclose($fp);
				return $contents;
			}
		}
				
	    return null;
	}

}