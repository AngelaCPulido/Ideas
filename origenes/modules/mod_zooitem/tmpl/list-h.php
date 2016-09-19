<?php
/**
* @package   ZOO Item Module
* @file      list-h.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// include css
JHTML::stylesheet('style.css', JURI::base().'modules/mod_zooitem/tmpl/list-h/');

// include js
JHTML::script('mod_zooitem.js', JURI::base().'modules/mod_zooitem/');

$count = count($items);

?>

<div class="zoo-item list-h">

	<?php if ($count) : ?>

		<ul>
			<?php $i = 0; foreach ($items as $item) : ?>
			<li class="width<?php echo intval(100 / $count);?> <?php if ($i % 2 == 0) { echo 'odd'; } else { echo 'even'; } ?>">
				<div class="match-height"><?php echo $renderer->render('item.'.$layout, compact('item', 'params')); ?></div>
			</li>
			<?php $i++; endforeach; ?>
		</ul>
		
	<?php else : ?>
		<?php echo JText::_('No items found'); ?>
	<?php endif; ?>
		
</div>

<script type="text/javascript">

	window.addEvent('domready', function() {
		$$('div.zoo-item').each(function (elm) {
			if (elm.hasClass('list-h')) {
				modZooItem.matchHeight(elm.getElements('div.match-height'), 0);
			}			
		});	
	});

</script>