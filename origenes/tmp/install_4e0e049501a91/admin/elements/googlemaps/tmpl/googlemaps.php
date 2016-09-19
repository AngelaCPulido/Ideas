<?php
/**
* @package   ZOO Component
* @file      googlemaps.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// add js
$document = JFactory::getDocument();
$document->addScript('http://maps.google.com/maps?file=api&amp;v=2&amp;key='.$google_api_key);
$document->addScript(ZOO_ADMIN_URI.'elements/googlemaps/googlemaps.js');

?>
<div class="googlemaps" style="<?php echo $css_module_width ?>">

	<?php if ($information) : ?>
	<p class="mapinfo"><?php echo $information; ?></p>
	<?php endif; ?>
	
	<div id="<?php echo $maps_id ?>" style="<?php echo $css_module_width . $css_module_height ?>"></div>
	
</div>
<?php echo "<script type=\"text/javascript\" defer=\"defer\">\n// <!--\n$javascript\n// -->\n</script>\n"; ?>