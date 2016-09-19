<?php
/**
* @package   ZOO Component
* @file      itemrenderer.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

/*
	Class: ItemRenderer
		The class for rendering items and its assigned positions.
*/
class ItemRenderer extends YRenderer {

	protected $_item;
	protected $_config;
	protected $_config_file = 'positions.config';
	protected $_xml_file = 'positions.xml';

	/*
		Function: render
			Render objects using a layout file.

		Parameters:
			$layout - Layout name.
			$args - Arguments to be passed to into the layout scope.

		Returns:
			String
	*/
	public function render($layout, $args = array()) {
		
		// set item
		$this->_item = isset($args['item']) ? $args['item'] : null;

		// render layout
		return parent::render($layout, $args);

	}
	
	/*
		Function: checkPosition
			Check if position generates output.

		Parameters:
			$position - Position name.

		Returns:
			Boolean
	*/
	public function checkPosition($position) {
	
		// init vars
		$app    = $this->_item->getApplication();
		$type   = $this->_item->getType();
		$config = $this->getConfig('item')->get($app->getGroup().'.'.$type->id.'.'.$this->_layout);
	
		if ($config && isset($config->$position)) {
			foreach ($config->$position as $data) {
				if ($element = $this->_item->getElement($data->element)) {
					if ($element->hasValue((array) $data)) {
						return true;
					}
				}
			}
		}
	
		return false;
	}

	/*
		Function: renderPosition
			Render position output.

		Parameters:
			$position - Position name.
			$args - Arguments to be passed to into the position scope.

		Returns:
			Void
	*/
	public function renderPosition($position, $args = array()) {

		// init vars
		$app      = $this->_item->getApplication();
		$type     = $this->_item->getType();
		$config   = $this->getConfig('item')->get($app->getGroup().'.'.$type->id.'.'.$this->_layout);
		$elements = array();
		$output   = '';
		
		// get style
		$style = isset($args['style']) ? $args['style'] : 'default';

		// get renderer
		$renderer = new YRenderer();
		$renderer->addPath($this->_path);

		// render elements
		if ($config && isset($config->$position)) {
			foreach ($config->$position as $i => $data) {
				if ($element = $this->_item->getElement($data->element)) {

					// set params
					$params = array_merge((array) $data, $args);
					
					// check value
					if ($element->hasValue($params)) {
						$elements[] = compact('element', 'params');
					}					
				}
			}

			foreach ($elements as $i => $data) {				
				$params  = array_merge(array('first' => ($i == 0), 'last' => ($i == count($elements)-1), 'layout_path' => $this->_path), $data['params']);
				$output .= $renderer->render("element.$style", array('element' => $data['element'], 'params' => $params));
			}
		}
		
		return $output;
	}

	/*
		Function: getPositions
			Retrieve positions of a layout.
			
		Parameter:
			$dir - point separated path to layout, last part is layout

		Returns:
			Array
	*/
	public function getPositions($dir) {
		
		// init vars
		$positions = array();
		
		$parts  = explode('.', $dir);
		$layout = array_pop($parts);
		$path   = implode('/', $parts);

		// parse positions xml
		if ($xml = YXML::loadFile(JPath::find($this->_getPath($path), $this->_xml_file))) {
			foreach ($xml->children() as $pos) {
				if ((string) $pos->attributes()->layout == $layout) {
					$positions['name'] = $layout;

					foreach ($pos->children() as $child) {
						
						if ($child->getName() == 'name') {
							$positions['name'] = (string) $child;
						}
						
						if ($child->getName() == 'position') {
							if ($child->attributes()->name) {
								$name = (string) $child->attributes()->name;
								$positions['positions'][$name] = (string) $child;
							}
						}
					}
					
					break;
				}
			}
		}

		return $positions;
	}

	/*
		Function: getConfig
			Retrieve position configuration.

		Parameter:
			$dir - path to config file

		Returns:
			YParameter
	*/
	public function getConfig($dir) {

		// config file
		if (empty($this->_config)) {

			if ($file = JPath::find($this->_getPath($dir), $this->_config_file)) {
				$content = JFile::read($file);
			} else {
				$content = null;
			}

			$this->_config = new YParameter();
			$this->_config->loadString($content);
		}
		
		return $this->_config;
	}

	/*
		Function: saveConfig
			Save position configuration.

		Parameter:
			$config - Configuration
			$file - File to save configuration

		Returns:
			Boolean
	*/
	public function saveConfig($config, $file) {

		if (JFile::exists($file) && !is_writable($file)) {
			throw new YException(sprintf('The config file is not writable (%s)', $file));
		}
		
		if (!JFile::exists($file) && !is_writable(dirname($file))) {
			throw new YException(sprintf('Could not create config file (%s)', $file));
		}

		return JFile::write($file, $config->toString());
	}
	
	public function pathExists($dir) {
		foreach ($this->_getPath($dir) as $path) {
			if (JFolder::exists($path)) {
				return true;
			}
		}
		return false;
	}	
	
}