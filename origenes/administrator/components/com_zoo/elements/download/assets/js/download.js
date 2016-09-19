/* Copyright (C) 2007 - 2010 YOOtheme GmbH, YOOtheme License (http://www.yootheme.com/license) */

Zoo.ElementDownload=new Class({initialize:function(a,b){var c=this;this.url=b;this.div=$(a);this.div.getElement('input[name="reset-hits"]').addEvent("click",function(){c.resetHits()})},resetHits:function(){(new Ajax(this.url+"&task=callelement&method=reset",{method:"post",update:this.div})).request()}}); 
