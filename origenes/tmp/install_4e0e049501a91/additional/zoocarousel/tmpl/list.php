<?php
/**
* @package   ZOO Carousel Module
* @file      list.php
* @version   1.5.0 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');
?>
<div class="<?php echo $theme ?>">
	<div id="<?php echo $carousel_id ?>" class="yoo-carousel" style="<?php echo $css_module_width . $css_module_height ?>">

		<div class="<?php echo $control_panel ?>" style="overflow: hidden;">

			<div class="panel-container-t" style="<?php echo $css_module_width ?>">
				<div class="panel-container-b">
					<div class="panel-container-l">
						<div class="panel-container-r">
							<div class="panel-container-tl">
								<div class="panel-container-tr">
									<div class="panel-container-bl">
										<div class="panel-container-br" style="<?php echo $css_panel_height ?>">

											<?php if ($control_panel == 'left') : ?>
											<ul class="tabs" style="<?php echo $css_tab_width . $css_panel_height ?>">
												<?php $i = 0; ?>
												<?php foreach ($items as $item) : ?>
													<li class="button item<?php echo $i + 1 ?>">
														<a href="javascript:void(0)" title="<?php echo $item->name; ?>">
															<span><span><?php echo $item->name; ?></span></span>
														</a>
													</li>
													<?php $i++; ?>
												<?php endforeach; ?>
											</ul>
											<?php endif; ?>
									
											<div class="frame" style="<?php echo $css_panel_width . $css_panel_height ?>">
							
												<div class="panel" style="<?php echo $css_panel_width ?>">
													<div style="<?php echo $css_total_panel_width ?>">
													<?php foreach ($items as $item) : ?>
														<div class="slide" style="<?php echo $css_panel_width ?><?php echo $css_slide_position ?>">
															<div class="item"><?php echo $renderer->render('item.'.$layout, compact('item', 'params')); ?></div>
														</div>
													<?php endforeach; ?>
													</div>
												</div>
									
											</div>
									
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
	
		</div>
		
	</div>
</div>