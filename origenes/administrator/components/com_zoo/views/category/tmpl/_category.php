<?php 
/**
* @package   ZOO Component
* @file      _category.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/
	
	defined('_JEXEC') or die('Restricted access');

	$link       = JRoute::_($this->baseurl.'&task=edit&cid[]='.$category->id);
	$link_items = JRoute::_($this->link_base.'&controller=item&filter_category_id='.$category->id.'&filter_type=&filter_author_id=&search=');
	$published  = JHTML::_('grid.published', $category, $this->i);
	$checked    = JHTML::_('grid.id', $this->i, $category->id);	
	$this->i++;
	
?>
<li>
	<table>
		<tbody>
			<tr>
				<td class="handle"></td>
				<td class="checkbox">
					<?php echo $checked; ?>
				</td>
				<td class="icon"></td>
				<td class="name">
					<span class="editlinktip hasTip" title="<?php echo JText::_('Edit Category');?>::<?php echo $category->name; ?>">
						<a href="<?php echo $link  ?>"><?php echo $category->name; ?></a>
					</span>
				</td>
				<td class="items">
					<a href="<?php echo $link_items; ?>"><?php echo $category->item_count; ?></a>
				</td>
				<td class="published">
					<?php echo $published;?>
				</td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="category[<?php echo $category->id; ?>]" value="<?php echo $category->id; ?>" />
	<input type="hidden" name="parent[<?php echo $category->id; ?>]" value="<?php echo $category->parent; ?>" />
	<input type="hidden" name="ordering[<?php echo $category->id; ?>]" value="<?php echo $category->ordering; ?>" />
	<?php if ($children = $category->getChildren()) : ?>
		<ul>
			<?php
				foreach ($children as $child) {
					echo $this->partial('category', array('category' => $child));
				}
			?>
		</ul>
	<?php endif; ?>
</li>