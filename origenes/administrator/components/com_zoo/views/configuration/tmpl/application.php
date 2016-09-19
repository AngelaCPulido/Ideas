<?php defined('_JEXEC') or die('Restricted access');

// add js
JHTML::script('configuration.js', 'administrator/components/com_zoo/assets/js/');

JHTML::_('behavior.tooltip');	

// filter output
JFilterOutput::objectHTMLSafe($this->application, ENT_QUOTES, array('params')); 

?>

<form id="configuration-application" class="menu-has-level3" action="index.php" method="post" name="adminForm" accept-charset="utf-8">

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
				<td>
					<input class="inputbox" type="text" name="name" id="name" size="60" value="<?php echo $this->application->name; ?>" />
				</td>
			</tr>
			<tr>
				<td width="110" class="key">
					<label for="alias">
						<?php echo JText::_('Template'); ?>
					</label>
				</td>
				<td>
					<?php echo $this->lists['select_template']; ?>
				</td>
			</tr>	
		</table>
		</fieldset>

	</div>

	<div class="col col-right width-40">

		<div id="parameter-accordion">
			<?php echo $this->partial('applicationparams')?>	
		</div>

	</div>

</div>

<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
<input type="hidden" name="task" value="" />
<input type="hidden" name="format" value="" />
<?php echo JHTML::_('form.token'); ?>

</form>

<script type="text/javascript">
	window.addEvent('domready', function(){
		var app = new Zoo.ApplicationEdit({application_id: '<?php echo $this->application->id;?>', application_group: '<?php echo $this->application->getGroup();?>'});
	});
</script>

<?php echo ZOO_COPYRIGHT; ?>