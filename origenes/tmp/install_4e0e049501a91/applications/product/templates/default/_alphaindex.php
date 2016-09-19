<?php
/**
* @package   ZOO Component
* @file      _alphaindex.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

?>

<div class="alpha-index">
	<div class="alpha-index-2">
		<div class="alpha-index-3">
			<?php echo $this->alpha_index->render($this->link_base.'&task=alphaindex&app_id='.$this->application->id); ?>			
		</div>
	</div>
</div>