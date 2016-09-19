<?php 
/**
* @package   ZOO Component
* @file      edit.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/
	defined('_JEXEC') or die('Restricted access'); 
		
	JHTML::_('behavior.tooltip');	
	
	// add script
	JHTML::script('observer.js', 'administrator/components/com_zoo/assets/js/');	
	JHTML::script('alias.js', 'administrator/components/com_zoo/assets/js/');
	JHTML::script('category.js', 'administrator/components/com_zoo/assets/js/');
	
	// filter output
	JFilterOutput::objectHTMLSafe($this->category, ENT_QUOTES, array('params')); 
?>

<form id="category-default" action="index.php" method="post" name="adminForm" accept-charset="utf-8">

<?php echo $this->partial('menu'); ?>

<div class="box-bottom">

	<div class="col col-left width-60">
		
		<fieldset>
		<legend><?php echo JText::_('Details'); ?></legend>
		<table class="admintable">
			<tr>
				<td width="110" class="key">
					<label for="name">
						<?php echo JText::_('Name'); ?>
					</label>
				</td>
				<td id="name-edit">
					<div>
						<input class="inputbox" type="text" name="name" id="name" size="60" value="<?php echo $this->category->name; ?>" />
						<span class="message-name"><?php echo JText::_('Please enter valid name.'); ?></span>
					</div>
					<span><?php echo JText::_('Slug'); ?>:</span>
					<a class="trigger" href="#" title="<?php echo JText::_('Edit Category Slug');?>"><?php echo $this->category->alias; ?></a>
					<div class="panel">
						<input type="text" name="alias" value="<?php echo $this->category->alias; ?>"></input>
						<input type="button" class="accept" value="<?php echo JText::_('Accept'); ?>">
						<a href="#" class="cancel"><?php echo JText::_('Cancel'); ?></a>
					</div>
				</td>
			</tr>
			<tr>
				<td width="110" class="key">
					<label>
						<?php echo JText::_('Published'); ?>
					</label>
				</td>
				<td>
					<?php echo $this->lists['select_published']; ?>
				</td>
			</tr>					
			<tr>
				<td class="key" align="right" valign="top">
					<?php echo JText::_('Parent Item'); ?>
				</td>
				<td>
					<?php echo $this->lists['select_parent']; ?>
				</td>
			</tr>
			<tr>
				<td class="key" valign="top">
					<label>
						<?php echo JText::_('Description'); ?>
					</label>
				</td>
				<td>
					<?php
						// parameters : areaname, content, width, height, cols, rows, show xtd buttons
						echo JFactory::getEditor()->display('description', $this->category->description, null, null, '60', '20', array('pagebreak', 'readmore')) ;	
					?>
				</td>
			</tr>		
		</table>
		</fieldset>

	</div>
	
	<div class="col col-right width-40">

		<div id="parameter-accordion">
			<h3 class="toggler"><?php echo JText::_('Content'); ?></h3>
			<div class="content">
				<?php echo $this->application->getParamsForm()->setValues($this->params->get('content.'))->render('params[content]', 'category-content'); ?>
			</div>
			<h3 class="toggler"><?php echo JText::_('Config'); ?></h3>
			<div class="content">
				<?php echo $this->application->getParamsForm()->setValues($this->params->get('config.'))->render('params[config]', 'category-config'); ?>
			</div>			
			<h3 class="toggler"><?php echo JText::_('Template'); ?></h3>
			<div class="content">
				<?php
					if ($template = $this->application->getTemplate()) {
						echo $template->getParamsForm(true)->setValues($this->params->get('template.'))->render('params[template]', 'category');
					} else {
						echo '<em>'.JText::_('Please select a Template').'</em>';
					}
				?>
			</div>
		</div>

	</div>

</div>

<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
<input type="hidden" name="task" value="" />
<input type="hidden" name="id" value="<?php echo $this->category->id; ?>" />
<input type="hidden" name="cid[]" value="<?php echo $this->category->id; ?>" />
<?php echo JHTML::_('form.token'); ?>

</form>

<script type="text/javascript">

	window.addEvent('domready', function(){
		var app = new Zoo.AliasEdit({ edit: <?php echo (int)$this->category->id; ?> });
		var app_category = new Zoo.EditCategory();
		$E('input[name="name"]', 'name-edit').focus();
	});

</script>

<?php echo ZOO_COPYRIGHT; ?>