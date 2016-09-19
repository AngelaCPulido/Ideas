/* Copyright (C) 2007 - 2010 YOOtheme GmbH, YOOtheme License (http://www.yootheme.com/license) */

var ElementRating=new Class({initialize:function(e,d){this.element=$(e);this.url=d;var b=this,a=this.element.getElements("div.stars");a.each(function(c,f){c.addEvent("click",function(){b.vote(a.length-f)});c.addEvent("mouseenter",function(){c.addClass("hover")});c.addEvent("mouseleave",function(){c.removeClass("hover")})})},vote:function(e){var d=this;(new Ajax(this.url,{method:"post",data:"method=vote&args[0]="+e,onComplete:function(b){var a=b.split(",");b=a[0];a=a[1];b>0&&d.element.getElement("div.previous-rating").setStyle("width",
b+"%");d.element.getElement("div.vote-message").setHTML(a)}})).request()}});ElementRating.implement(new Options); 
