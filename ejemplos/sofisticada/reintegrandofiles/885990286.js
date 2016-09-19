/* Vermont-12.4.0-1082 */
rsinetsegs=['D08734_70625','D08734_70065','D08734_72078','D08734_72014','D08734_72013','D08734_72010','D08734_72011','D08734_72012','D08734_72016','D08734_72017','D08734_72083','J08778_50014'];
var rsiExp=new Date((new Date()).getTime()+2419200000);
var rsiDom=location.hostname;
rsiDom=rsiDom.replace(/.*(\.[\w\-]+\.[a-zA-Z]{3}$)/,'$1');
rsiDom=rsiDom.replace(/.*(\.[\w\-]+\.\w+\.[a-zA-Z]{2}$)/,'$1');
rsiDom=rsiDom.replace(/.*(\.[\w\-]{3,}\.[a-zA-Z]{2}$)/,'$1');
var rsiSegs="";
var rsiPat=/.*_5.*/;
for(x=0;x<rsinetsegs.length;++x){if(!rsiPat.test(rsinetsegs[x]))rsiSegs+='|'+rsinetsegs[x];}
document.cookie="rsi_segs="+(rsiSegs.length>0?rsiSegs.substr(1):"")+";expires="+rsiExp.toGMTString()+";path=/;domain="+rsiDom;
if(typeof(DM_onSegsAvailable)=="function"){DM_onSegsAvailable(['D08734_70625','D08734_70065','D08734_72078','D08734_72014','D08734_72013','D08734_72010','D08734_72011','D08734_72012','D08734_72016','D08734_72017','D08734_72083','J08778_50014'],'j08778');}