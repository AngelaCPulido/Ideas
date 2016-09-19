<?php
/**
* @package   ZOO Component
* @file      download.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// register parent class
JLoader::register('ElementFile', ZOO_ADMIN_PATH.'/elements/file/file.php');

/*
	Class: ElementDownload
		The file download element class
*/
class ElementDownload extends ElementFile {

	/*
	   Function: Constructor
	*/
	public function __construct() {

		// call parent constructor
		parent::__construct();

		// set defaults
		$this->_config->set('secret', JFactory::getConfig()->getValue('config.secret'));

		// set callbacks
		$this->registerCallback('download');
		$this->registerCallback('reset');
	}

	/*
		Function: getSize
			Gets the download file size.

		Returns:
			String - Download file with KB/MB suffix
	*/
	public function getSize() {
		return YFile::formatFilesize($this->_data->get('size', 0));
	}
	
	/*
		Function: getSize
			Gets the download file size.

		Returns:
			String - Download file with KB/MB suffix
	*/
	function isDownloadLimitReached() {

		$limit = $this->_data->get('download_limit');
		if ($limit && $this->_data->get('hits', 0) >= $limit) {
			return true;
		}
		return false;
	}
	
	/*
	   Function: getExtension
	       Get the file extension string.

	   Returns:
	       String - file extension
	*/
	public function getExtension() {

		$file = $this->_data->get('file');
		if ($file) {
			return YFile::getExtension($file);
		}

		return null;
	}

	/*
		Function: getLink
			Gets the link to the download.

		Returns:
			String - link
	*/
	public function getLink() {
		
		// init vars
		$file		   = $this->_data->get('file');
		$download_mode = $this->_config->get('download_mode');

		// create download link
		$link = 'index.php?option=com_zoo&task=callelement&format=raw&item_id='.$this->_item->id;

		if ($download_mode == 1) {
			return $link.'&element='.$this->identifier.'&method=download';
		} else if ($download_mode == 2) {
			return $link.'&element='.$this->identifier.'&method=download&args[0]='.$this->filecheck();
		} else {
			return trim($this->_config->get('directory', ''), '/').'/'.$file;
		}

	}

	/*
		Function: render
			Renders the element.

	   Parameters:
   			$params - render parameter

		Returns:
			String - html
	*/
	public function render($params = array()) {
		
		// init vars
		$filename      = basename($this->_data->get('file'));
		$download_link = $this->getLink();
		$filetype      = str_replace('.','',$this->getExtension());
		$params		   = new YArray($params);
		$display       = $params->get('display', null);
		$download_name = $params->get('download_name', '');
		$download_name = JString::str_ireplace('{filename}', $filename, $download_name);

		// render layout
		if ($layout = $this->getLayout()) {
			return self::renderLayout($layout, array('file' => $this->_data->get('file'), 'filename' => $filename, 'size' => $this->getSize(), 'hits' => (int) $this->_data->get('hits', 0), 'download_name' => $download_name, 'download_link' => $download_link, 'filetype' => $filetype, 'display' => $display, 'limit_reached' => $this->isDownloadLimitReached(), 'download_limit' => $this->_data->get('download_limit')));
		}
		
		return null;
	}

	/*
		Function: download
			Download the file.

		Returns:
			Binary - File data
	*/
	public function download($check = '') {
		
		// init vars
		$directory = $this->_config->get('directory');
		$filepath = rtrim(JPATH_ROOT.DS.$directory, '/').'/'.$this->_data->get('file');
		$download_mode = $this->_config->get('download_mode');
		
		// check limit
		if ($this->isDownloadLimitReached()) {
			header('Content-Type: text/html');
			echo JText::_('Download limit reached!');
			return;
		}

		// output file
		if ($download_mode == 1 && is_readable($filepath) && is_file($filepath)) {
			$this->_data->set('hits', $this->_data->get('hits', 0) + 1);
			YFile::output($filepath);
		} else if ($download_mode == 2 && $this->filecheck() == $check && is_readable($filepath) && is_file($filepath)) {
			$this->_data->set('hits', $this->_data->get('hits', 0) + 1);
			YFile::output($filepath);
		} else {
			header('Content-Type: text/html');
			echo JText::_('Invalid file!');
		}
		// save item
		YTable::getInstance('item')->save($this->getItem());

	}

	/*
	   Function: filecheck
	       Get the file check string.

	   Returns:
	       String - md5(file + secret + date) 
	*/
	public function filecheck() {
		$secret = $this->_config->get('secret');
		return md5($this->_data->get('file').$secret.date('Y-m-d'));
	}

	/*
	   Function: edit
	       Renders the edit form field.

	   Returns:
	       String - html
	*/
	public function edit(){

		// create info
		$info[] = JText::_('Size').': '.$this->getSize();
		$info[] = JText::_('Hits').': '.(int)$this->_data->get('hits', 0);
		$info   = ' ('.implode(', ', $info).')';

		$javascript = '';
		$reset = '';
		if ($this->_data->get('hits', 0)) {
			
			$option     = JRequest::getCmd('option');
			$controller = JRequest::getWord('controller');
			
			$reset = '<input name="reset-hits" type="button" class="button" value="'.JText::_('Reset').'"/>';
			
			// create js
			$javascript  = "var download = new Zoo.ElementDownload('".$this->identifier."', '".JRoute::_('index.php?option='.$option.'&controller='.$controller.'&format=raw&type='.$this->getType()->id.'&elm_id='.$this->identifier.'&item_id='.$this->getItem()->id, false)."');";
			$javascript  = "<script type=\"text/javascript\">\n// <!--\n$javascript\n// -->\n</script>\n";			
		}
		
		$html  = '<div id="'.$this->identifier.'">';
		$html .= parent::edit() . $info . $reset;		
		$html .= '<table>';		
		$html .= JHTML::_('element.editrow', JText::_('Download limit'), JHTML::_('control.text', 'elements[' . $this->identifier . '][download_limit]', $this->_data->get('download_limit'), 'size="6" maxlength="255"'));
		$html .= '</table>';		
		$html .= '</div>';
		
		return $html.$javascript;

	}

	/*
		Function: loadAssets
			Load elements css/js assets.

		Returns:
			Void
	*/
	public function loadAssets() {
		JHTML::script('download.js', 'administrator/components/com_zoo/elements/download/assets/js/');

		return $this;
	}	
	
	public function reset() {
		
		$this->_data->set('hits', 0);
		
		//save item
		YTable::getInstance('item')->save($this->getItem());		
		
		return $this->edit();
	}	
	
	/*
		Function: bindData
			Set data through data array.

		Parameters:
			$data - array

		Returns:
			Void
	*/	
	public function bindData($data = array()) {
		
		if (!isset($data['hits'])) {
			$this->setData($this->getItem()->elements);
			$data['hits'] = $this->_data->get('hits', 0);
		}
		
		parent::bindData($data);
	}	
	
}

class ElementDownloadData extends ElementData{

	public function encodeData() {		
	
		// add size to xml
		$filepath = rtrim(JPATH_ROOT.DS.$this->_element->getConfig()->get('directory'), '/').'/'.$this->get('file');
		if (is_readable($filepath) && is_file($filepath)) {
			$this->set('size', sprintf('%u', filesize($filepath)));
		} else {
			$this->set('size', 0);
		}			
		
		return parent::encodeData();
		
	}		
	
}