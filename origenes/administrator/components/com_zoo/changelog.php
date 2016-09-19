<?php
/**
* @package   ZOO Component
* @file      changelog.php
* @version   2.0.1 May 2010
* @author    YOOtheme http://www.yootheme.com
* @copyright Copyright (C) 2007 - 2010 YOOtheme GmbH
* @license   http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 only
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

?>

Changelog
------------

2.0.1
+ googlemaps element now renders item layout in popup
# fixed bug with Twitter Authenticate and SEF turned on
+ added category module
# fixed translation of country element
# fixed language files to include googlemaps element
# fixed minor css issue with category columns
^ updated item module to version 2.0.1
^ updated search plugin to version 2.0.1
# fixed categories teaser description in cookbook app
+ country element is now searchable
^ changes to the applications installer, now accepts different archive types
# fixed bug with rss feed item order
# fixed bug with comment cookie scope
# fixed minor CSS issue with comments in documentation app
# fixed filtering bug for relateditems element
# fixed bug with utf-8 encoding of the default.js file
# fixed bug with saving utf-8 encoded item-, category-, type slugs
# fixed bug with breadcrumbs (direct link to item)
+ added some exceptions to the application installer
# fixed bug with alpha index

2.0.0
^ changed error message for position.config not writable
# fixed bug with gifs in imagethumbnail
# fixed bug with removing last tag from item
# fixed bugs with editing tags on item edit in browsers with webkit engine

2.0.0 RC 2
# fixed breadcrumbs in item view
# fixed bug with comment login cookie
^ added check script to installation process
# fixed bug with exception class name
# fixed comment filters in backend
# fixed bug with special character in app name
$ updated language files
# fixed capital characters in position names
# fixed option parameter in element links
^ relateditems ordered by default are now ordered as ordered in item view

2.0.0 RC
# fixed relateditem.js
# try to set timelimit in installer

2.0.0 BETA 4
# fixed bug with item copy, if no item is selected
# fixed bug with install script
# fixed bug with image element link
# fixed bug with related items import
# fixed bug with tag import
# special characters in textarea and text control
# fixed relateditems delete

2.0.0 BETA 3
# fixed "add options" bug in edit elements view
# fixed parameter settings in ZOO administration panel
^ updated addthis element
# fixed pagination on frontpage layout in SEO mode
# fixed link in item module
# fixed link in image element
# fixed generated link through menu_item parameter in module
+ added update functionality to ZOO installer
# fixed links to ZOO in rss feed
^ changed editor handling in ZOO administration panel
^ if menuitem is direct link to item, the category won't be added to breadcrump
# moved applications group field from params to database field

2.0.0 BETA 2
+ added support for unicode characters (cyrillic, arabic, ...) in slug
+ added application wide use of tinyMCE editors in Joomla administration panel
+ added comment author caching
# PHP 4 warning now functions as expected
# use of htmlentities before output to text and textarea fields
^ merged commentauthor classes into single file
# vertical tabs are being filtered from CData areas in xml
# image element: added file exist check
# bugfixes to import/export
# fixed some tooltips in Joomla administration panel
# bugfixes to install application
# bugfixes to comments
# bugfix in type delete

2.0.0 BETA
+ Initial Release



* -> Security Fix
# -> Bug Fix
$ -> Language fix or change
+ -> Addition
^ -> Change
- -> Removed
! -> Note