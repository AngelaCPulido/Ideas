<?php
/**
* @package   ZOO Component
* @file      email.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// register yoo gallery class
JLoader::register('ElementRepeatable', ZOO_ADMIN_PATH.'/elements/repeatable/repeatable.php');

/*
   Class: ElementEmail
       The email element class
*/
class ElementEmail extends ElementRepeatable {

	/*
		Function: _hasValue
			Checks if the repeatables element's value is set.

	   Parameters:
			$params - render parameter

		Returns:
			Boolean - true, on success
	*/	
	protected function _hasValue($params = array()) {
		$value = $this->_data->get('value');
		return $this->_containsEmail($value);
	}	
	
	/*
		Function: getText
			Gets the email text.

		Returns:
			String - text
	*/
	public function getText() {
		
		// init vars
		$use_email_as_text = $this->_config->get('use_email_as_text');
		$default_text = $this->_config->get('default_text');	
				
		if ($use_email_as_text) {
			return $this->_data->get('value', '');
		} else if (!empty($default_text)) {
			return $default_text;
		} else {
			return $this->_data->get('text', '');
		}
	}

	/*
		Function: getSubject
			Gets the email subject.

		Returns:
			String - subject
	*/
	public function getSubject() {
		
		// init vars
		$default_subject = $this->_config->get('default_subject');
				
		if (empty($default_subject)) {
			return $this->_data->get('subject', '');
		} else {
			return $default_subject;
		}
	}
	
	/*
		Function: getBody
			Gets the email body.

		Returns:
			String - body
	*/
	public function getBody() {
		
		// init vars
		$default_body = $this->_config->get('default_body');		

		if (empty($default_body)) {
			return $this->_data->get('body', '');
		} else {
			return $default_body;
		}
	}	

	/*
		Function: render
			Renders the repeatable element.

	   Parameters:
            $params - render parameter

		Returns:
			String - html
	*/
	protected function _render($params = array()) {

		// init vars
		$mode 		= $this->_containsEmail($this->getText());
		$subject 	= ($this->getSubject()) ? 'subject=' . $this->getSubject() : '';
		$body 		= ($this->getBody()) ? 'body=' . $this->getBody() : '';
		$mailto 	= $this->_data->get('value', '');
		$text	 	= $this->getText();
						
		if ($subject && $body) {
			$mailto	.= '?' . $subject . '&' . $body;
		} elseif ($subject || $body) {
			$mailto	.= '?' . $subject . $body;
		}
		
		return JHTML::_('email.cloak', $mailto, true, $text, $mode);

	}
	
	/*
	   Function: _edit
	       Renders the repeatable edit form field.

	   Returns:
	       String - html
	*/		
	protected function _edit(){

		// init vars
		$use_email_as_text 	= $this->_config->get('use_email_as_text');
		$default_text 		= $this->_config->get('default_text');
		$default_subject 	= $this->_config->get('default_subject');
		$default_body 		= $this->_config->get('default_body');	
		
		// create html
		$html  = '<table>';
		
		// email text
		if (!$use_email_as_text && empty($default_text)) {
			$html .= JHTML::_('element.editrow', JText::_('Link Text'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][text]', $this->getText(), 'size="60"'));
		}
		// email address
		$html .= JHTML::_('element.editrow', JText::_('Email'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][value]', $this->_data->get('value', ''), 'size="60" maxlength="255"'));

		// email subject
		if (empty($default_subject)) {
			$html .= JHTML::_('element.editrow', JText::_('Subject'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][subject]', $this->getSubject(), 'size="60"'));
		}
		// email body
		if (empty($default_body)) {
			$html .= JHTML::_('element.editrow', JText::_('Body'), JHTML::_('control.text', 'elements[' . $this->identifier . ']['.$this->index().'][body]', $this->getBody(), 'size="60"'));
		}
		$html .= '</table>';

		return $html;	
	}	

	/*
	   Function: _containsEmail
	       Checks for an email address in a text.

	   Returns:
	       Boolean - true if text contains email address, else false
	*/
	protected function _containsEmail($text) {
		return preg_match('/[\w!#$%&\'*+\/=?`{|}~^-]+(?:\.[!#$%&\'*+\/=?`{|}~^-]+)*@(?:[A-Z0-9-]+\.)+[A-Z]{2,6}/i', $text);
	}

}