<?php
class JConfig {
/* Site Settings */
var $offline = '0';
var $offline_message = 'El sitio está desactivado por tareas de mantenimiento <br /> Por favor, vuelva más tarde.';
var $sitename = 'origenes2.org.co';
var $editor = 'tinymce';
var $list_limit = '20';
var $legacy = '0';
/* Debug Settings */
var $debug = '0';
var $debug_lang = '0';
/* Database Settings */
var $dbtype = 'mysql';
var $host = 'localhost';
var $user = 'root';
var $password = '';
var $db = 'joomla3';
var $dbprefix = 'jos_';
/* Server Settings */
var $live_site = '';
var $secret = 'U09tFM9Gff2ONpj4';
var $gzip = '0';
var $error_reporting = '-1';
var $helpurl = 'http://help.joomla.org';
var $xmlrpc_server = '0';
var $ftp_host = '127.0.0.1';
var $ftp_port = '21';
var $ftp_user = '';
var $ftp_pass = '';
var $ftp_root = '';
var $ftp_enable = '0';
var $force_ssl = '0';
/* Locale Settings */
var $offset = '0';
var $offset_user = '0';
/* Mail Settings */
var $mailer = 'mail';
var $mailfrom = 'design@empresariosporcolombia.org';
var $fromname = 'origenes2.org.co';
var $sendmail = '/usr/sbin/sendmail';
var $smtpauth = '0';
var $smtpsecure = 'none';
var $smtpport = '25';
var $smtpuser = '';
var $smtppass = '';
var $smtphost = 'localhost';
/* Cache Settings */
var $caching = '0';
var $cachetime = '15';
var $cache_handler = 'file';
/* Meta Settings */
var $MetaDesc = 'Joomla! - el motor de portales dinámicos y sistema de administración de contenidos';
var $MetaKeys = 'joomla, Joomla';
var $MetaTitle = '1';
var $MetaAuthor = '1';
/* SEO Settings */
var $sef           = '0';
var $sef_rewrite   = '0';
var $sef_suffix    = '0';
/* Feed Settings */
var $feed_limit   = 10;
var $feed_email   = 'author';
var $log_path = 'D:\\Program Files (x86)\\EasyPHP5.2.10\\www\\joomla2\\logs';
var $tmp_path = 'D:\\Program Files (x86)\\EasyPHP5.2.10\\www\\joomla2\\tmp';
/* Session Setting */
var $lifetime = '15';
var $session_handler = 'database';
}
?>