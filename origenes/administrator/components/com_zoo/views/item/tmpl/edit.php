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
	JHTML::script('autocompleter.js', 'administrator/components/com_zoo/assets/js/');
	JHTML::script('tag.js', 'administrator/components/com_zoo/assets/js/');
	JHTML::script('alias.js', 'administrator/components/com_zoo/assets/js/');
	JHTML::script('item.js', 'administrator/components/com_zoo/assets/js/');
	JHTML::script('sortablelist.js', 'administrator/components/com_zoo/assets/js/');

	// filter output
	JFilterOutput::objectHTMLSafe($this->item, ENT_QUOTES, array('params', 'elements')); 

?>

<form id="item-edit" action="index.php" method="post" name="adminForm" accept-charset="utf-8">

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
								<input class="inputbox" type="text" name="name" id="name" size="60" value="<?php echo $this->item->name; ?>"></input>
								<span class="message-name"><?php echo JText::_('Please enter valid name.'); ?></span>
							</div>
							<span><?php echo JText::_('Slug'); ?>:</span>
							<a class="trigger" href="#" title="<?php echo JText::_('Edit Item Slug');?>"><?php echo $this->item->alias; ?></a>
							<div class="panel">
								<input type="text" name="alias" value="<?php echo $this->item->alias; ?>"></input>
								<input type="button" class="accept" value="<?php echo JText::_('Accept'); ?>"/>
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
						<td width="110" class="key">
							<label>
								<?php echo JText::_('Searchable'); ?>
							</label>
						</td>
						<td>
							<?php echo $this->lists['select_searchable']; ?>
						</td>
					</tr>
					<tr>
						<td width="110" class="key">
							<label>
								<?php echo JText::_('Comments'); ?>
							</label>
						</td>
						<td>
							<?php echo $this->lists['select_enable_comments']; ?>
						</td>
					</tr>
					<tr>
						<td width="110" class="key">
							<label>
								<?php echo JText::_('Frontpage'); ?>
							</label>
						</td>
						<td>
							<?php echo $this->lists['select_frontpage']; ?>
						</td>
					</tr>								
					<tr>
						<td width="110" class="key">
							<label>
								<?php echo JText::_('Categories'); ?>
							</label>
						</td>
						<td>
							<?php echo $this->lists['select_categories']; ?>
						</td>
					</tr>
				</table>
				<table class="admintable">
					<tbody>
					<?php
						foreach ($this->item->getElements($this->item) as $element) {
							$element->loadAssets();
							
							// set label
							$name = $element->getConfig()->get('name');

							$description = $element->getConfig()->get('description');
							if ($description) {
								$name = '<span class="editlinktip hasTip" title="'.$description.'">'.$name.'</span>';
							}

							echo "\t<tr>\n";
							echo "\t\t<td class=\"key\">$name</td>\n";
							echo "\t\t<td>".$element->edit()."</td>\n";
							echo "\t</tr>\n";
						}
					?>
					</tbody>
				</table>
			</fieldset>

		</div>
		
		<div class="col col-right width-40">

			<table width="100%" class="infobox">
				<?php if ($this->item->id) : ?>
				<tr>
					<td>
						<strong><?php echo JText::_('Item ID'); ?>:</strong>
					</td>
					<td>
						<?php echo $this->item->id; ?>
					</td>
				</tr>
				<?php endif; ?>
				<tr>
					<td>
						<strong><?php echo JText::_('Type'); ?></strong>
					</td>
					<td>
						<?php echo $this->item->getType()->name; ?>
						<input type="hidden" name="type" value="<?php echo $this->item->type; ?>"></input>
					</td>
				</tr>					
				<tr>
					<td>
						<strong><?php echo JText::_('State'); ?></strong>
					</td>
					<td>
						<?php echo $this->item->state > 0 ? JText::_('Published') : ($this->item->state < 0 ? JText::_('Archived') : JText::_('Draft Unpublished'));?>
					</td>
				</tr>
				<tr>
					<td>
						<strong><?php echo JText::_('Hits'); ?></strong>
					</td>
					<td>
						<?php echo $this->item->hits;?>
						<span <?php echo !$this->item->hits ? 'style="display: none; visibility: hidden;"' : null; ?>>
							<input name="reset_hits" type="button" class="button" value="<?php echo JText::_('Reset'); ?>" onclick="submitbutton('resethits');"></input>
						</span>
					</td>
				</tr>
				<tr>
					<td>
						<strong><?php echo JText::_('Created'); ?></strong>
					</td>
					<td>
						<?php echo $this->item->created == $this->db->getNullDate() ? JText::_('New item') : JHTML::_('date', $this->item->created, JText::_('DATE_FORMAT_LC2')); ?>
					</td>
				</tr>
				<tr>
					<td>
						<strong><?php echo JText::_('Modified'); ?></strong>
					</td>
					<td>
						<?php echo $this->item->modified == $this->db->getNullDate() ? JText::_('Not modified') : JHTML::_('date', $this->item->modified, JText::_('DATE_FORMAT_LC2')); ?>
					</td>
				</tr>			
			</table>

			<?php
							
				// get item xml form
				$form = new YParameterFormDefault(dirname(__FILE__).'/params.xml');
			
				// set details parameter
				$details = new YParameter();
				$details->set('created_by', intval($this->item->created_by) ? intval($this->item->created_by) : $this->user->get('id'));
				$details->set('access', $this->item->access);
				$details->set('created_by_alias', $this->item->created_by_alias);
				$details->set('created', JHTML::_('date', $this->item->created, '%Y-%m-%d %H:%M:%S'));
				$details->set('publish_up', JHTML::_('date', $this->item->publish_up, '%Y-%m-%d %H:%M:%S'));
				$details->set('publish_down', JHTML::_('date', $this->item->publish_down, '%Y') <= 1969 || $this->item->publish_down == $this->db->getNullDate() ? JText::_('Never') : JHTML::_('date', $this->item->publish_down, '%Y-%m-%d %H:%M:%S'));
			
			?>

			<div id="parameter-accordion">
				<h3 class="toggler"><?php echo JText::_('Details'); ?></h3>
				<div class="content">
					<?php echo $form->setValues($details)->render('details'); ?>
				</div>
				<h3 class="toggler"><?php echo JText::_('Metadata'); ?></h3>
				<div class="content">
					<?php echo $form->setValues($this->params->get('metadata.'))->render('params[metadata]', 'metadata'); ?>
				</div>
				<h3 class="toggler"><?php echo JText::_('Template'); ?></h3>
				<div class="content">
					<?php
						if ($template = $this->application->getTemplate()) {
							echo $template->getParamsForm(true)->setValues($this->params->get('template.'))->render('params[template]', 'item');
						} else {
							echo '<em>'.JText::_('Please select a Template').'</em>';
						}
					?>
				</div>
				<h3 class="toggler"><?php echo JText::_('Tags'); ?></h3>
				<div class="content">
					<div id="tag-area">
						<div class="input">
							<div class="hint"><?php echo JText::_('Add new tag');?></div>
							<input type="text" value="" autocomplete="off"></input>
							<button class="button-grey" type="button"><?php echo JText::_('Add tag')?></button>
							<div class="icon"></div>						
						</div>
						<p><?php echo JText::_('Seperate multiple tags through commas'); ?>.</p>
						<div class="tag-list">
						<?php foreach ($this->item->getTags() as $tag) :?>
							<div>
								<a></a>
								<?php echo $tag; ?>
								<input type="hidden" value="<?php echo $tag; ?>" name="tags[]"></input>
							</div>
						<?php endforeach;?>	
						</div>
						<?php if (count($this->lists['most_used_tags'])) : ?>
						<p><?php echo JText::_('Choose from the most used tags');?>.</p>
						<div class="tag-cloud">
							<?php foreach ($this->lists['most_used_tags'] as $tag) :?>
								<a class="button-grey" title="<?php echo $tag->items . ' ' . ($tag->items == 1 ? JText::_('item') : JText::_('items')); ?>"><?php echo $tag->name; ?></a>
							<?php endforeach;?>
						</div>
						<?php endif; ?>
					</div>
				</div>
			</div>
		</div>
	</div>

<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
<input type="hidden" name="task" value="" />
<input type="hidden" name="id" value="<?php echo $this->item->id; ?>" />
<input type="hidden" name="cid[]" value="<?php echo $this->item->id; ?>" />
<input type="hidden" name="hits" value="<?php echo $this->item->hits; ?>" />
<?php echo JHTML::_('form.token'); ?>

</form>

<script type="text/javascript">
	window.addEvent('domready', function(){
		var app_tag = new Zoo.Tag();
		var app_alias = new Zoo.AliasEdit({ edit: <?php echo (int)$this->item->id; ?> });
		var app_item = new Zoo.EditItem();

		$E('input[name="name"]', 'name-edit').focus();
	});
</script>

<?php echo ZOO_COPYRIGHT; ?>