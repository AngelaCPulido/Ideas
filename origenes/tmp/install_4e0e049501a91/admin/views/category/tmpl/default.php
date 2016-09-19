<?php 
/**
* @package   ZOO Component
* @file      default.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access'); 

// add js
JHTML::script('category.js', 'administrator/components/com_zoo/assets/js/');
JHTML::script('sortabletree.js', 'administrator/components/com_zoo/assets/js/'); 

?>

<form id="categories-default" action="index.php" method="post" name="adminForm" accept-charset="utf-8">

<?php echo $this->partial('menu'); ?>

<div class="box-bottom">

	<?php if (count($this->categories) > 1) : ?>

		<div id="categories-list">
		
			<table>
				<thead>
					<tr>
						<th class="checkbox">
							<input type="checkbox" name="toggle" value="" onclick="checkAll(<?php echo count($this->categories); ?>);" />
						</th>
						<th class="name">
							<?php echo JText::_('Name'); ?>
						</th>
						<th class="items">
							<?php echo JText::_('Items'); ?>
						</th>
						<th class="published">
							<?php echo JText::_('Published'); ?>
						</th>
					</tr>
				</thead>
			</table>
		
			<ul id="categories">
				<?php
					$this->i = 0;
					foreach ($this->categories[0]->getChildren() as $category) {
						echo $this->partial('category', array('category' => $category));
					}
				?>
			</ul>
		
		</div>
	
	<?php else: 
	
			$title   = JText::_('NO_CATEGORIES_YET').'!';
			$message = JText::_('CATEGORY_MANAGER_DESCRIPTION');
			echo $this->partial('message', compact('title', 'message'));
		
	endif; ?>

</div>

<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
<input type="hidden" name="task" value="" />
<input type="hidden" name="boxchecked" value="0" />
<?php echo JHTML::_('form.token'); ?>

</form>

<script type="text/javascript">
	window.addEvent('domready', function(){
		var app = new Zoo.BrowseCategories();
	});
</script>

<?php echo ZOO_COPYRIGHT; ?>