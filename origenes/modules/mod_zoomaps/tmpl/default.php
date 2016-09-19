<?php
/**
* @package   ZOO Maps Module
* @file      default.php
* @version   1.5.0 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// include css
JHTML::stylesheet('style.css', JURI::base().'modules/mod_zoomaps/tmpl/default/');

?>

<div class="yoo-maps" style="<?php echo $css_module_width ?>">

	<div id="<?php echo $maps_id ?>" style="<?php echo $css_module_width . $css_module_height ?>"></div>
	
	<?php foreach ($messages as $message) : ?>
	<div class="alert"><strong><?php echo $message; ?></strong></div>
	<?php endforeach; ?>
	
</div>