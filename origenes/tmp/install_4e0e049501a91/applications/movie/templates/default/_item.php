<?php
/**
* @package   ZOO Component
* @file      _item.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

?>

<div class="teaser-item">
<?php if ($item) : ?>
	
	<?php echo $this->renderer->render('item.teaser', array('view' => $this, 'item' => $item)); ?>
	
<?php endif; ?>
</div>