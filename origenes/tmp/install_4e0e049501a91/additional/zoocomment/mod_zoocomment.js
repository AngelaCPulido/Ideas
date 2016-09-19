/* Copyright (C) 2007 - 2010 YOOtheme GmbH, YOOtheme License (http://www.yootheme.com/license) */

// create namespace
var modZooComment = {};

/* Match height of elements */
modZooComment.matchHeight = function(elements, min) {
	var max = 0;

	$$(elements).each(function(element, i){
		var height;
		if (element.offsetHeight) {
			height = element.offsetHeight;
		} else if (element.style.pixelHeight) {
			height = element.style.pixelHeight;
		}
		max = Math.max(max, height);
	});

	if (min != undefined) {
		max = Math.max(max, min);
	}

	$$(elements).each(function(element, i){
		var offset = element.getStyle('padding-top').toInt() + element.getStyle('padding-bottom').toInt() + element.getStyle('border-top-width').toInt() + element.getStyle('border-bottom-width').toInt();
		var height = max - offset;
		var style  = window.ie6 ? 'height' : 'min-height';
		element.setStyle(style, height + 'px');
	});
}