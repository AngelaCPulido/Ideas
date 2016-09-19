<?php
/**
* @package   ZOO Component
* @file      item.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// include assets css/js
if (strtolower(substr($GLOBALS['mainframe']->getTemplate(), 0, 3)) != 'yoo') {
	JHTML::stylesheet('reset.css', 'media/zoo/assets/css/');
}
JHTML::stylesheet('zoo.css.php', $this->template->getURI().'/assets/css/');

// include syntaxhighlighter
JHTML::script('shCore.js', $this->template->getURI().'/assets/js/syntaxhighlighter/scripts/');
JHTML::script('shBrushJScript.js', $this->template->getURI().'/assets/js/syntaxhighlighter/scripts/');
JHTML::script('shBrushCss.js', $this->template->getURI().'/assets/js/syntaxhighlighter/scripts/');
JHTML::script('shBrushPhp.js', $this->template->getURI().'/assets/js/syntaxhighlighter/scripts/');
JHTML::script('shBrushXml.js', $this->template->getURI().'/assets/js/syntaxhighlighter/scripts/');
JHTML::stylesheet('shCore.css', $this->template->getURI().'/assets/js/syntaxhighlighter/styles/');
JHTML::stylesheet('shThemeRDark.css', $this->template->getURI().'/assets/js/syntaxhighlighter/styles/');

$script   = array();
$script[] = 'SyntaxHighlighter.config.clipboardSwf = \''.$this->template->getURI().'/assets/js/syntaxhighlighter/scripts/clipboard.swf\';';
$script[] = 'SyntaxHighlighter.defaults[\'gutter\'] = false;';
$script[] = 'SyntaxHighlighter.all()';

JFactory::getDocument()->addScriptDeclaration(implode("\n", $script));

$css_class = $this->application->getGroup().'-'.$this->template->name;

?>

<div id="yoo-zoo" class="yoo-zoo <?php echo $css_class; ?> <?php echo $css_class.'-'.$this->item->alias; ?>">

	<div class="item">
	
		<?php echo $this->renderer->render('item.full', array('view' => $this, 'item' => $this->item)); ?>
		
	</div>

</div>