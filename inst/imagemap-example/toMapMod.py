def create_map(gene_Names, map_coord, idtype, organism):
    outstring = []
    for numline in range(len(gene_Names)):
        gene_line = gene_Names[numline]
        coords = map_coord[numline].split('\t')
        outstring.append(''.join(['<area shape="circle" coords="',
                            coords[0], ' ', coords[1], ' ', 
                            coords[2], 
                            '" title="',gene_line,
                            '" href="#', ## new
                            '" onClick="fixedtooltip(',str(numline + 1),
                            ', \'<a class=\\\'tip\\\' href=\\\'javascript:hidetip(',
                            str(numline + 1), ')\\\'>X</a><a class=\\\'tip2\\\' href=\\\'http://idclight.bioinfo.cnio.es/idclight.prog?',
                            '&idtype=', idtype, '&id=', gene_line, '&internal=0&org=', organism, '\\\'>',
                            gene_line, '</a>\', this, event, \'90px\'); return false"  > ']))
    return outstring

def create_map_none(gene_Names, map_coord, idtype, organism):
    """Like create_map, but when there are no known identifiers.
    It changes the javascript call"""
    outstring = []
    for numline in range(len(gene_Names)):
        gene_line = gene_Names[numline]
        coords = map_coord[numline].split('\t')
        outstring.append(''.join(['<area shape="circle" coords="',
                            coords[0], ' ', coords[1], ' ', 
                            coords[2], 
                            '" title="',gene_line,
                            '" href="#', 
                            '" onClick="fixedtooltip(',str(numline + 1),
                            ', \'<a class=\\\'tip\\\' href=\\\'javascript:hidetip(',
                            str(numline + 1), ')\\\'>X</a><a class=\\\'tip2\\\'>',
                            gene_line, '</a>\', this, event, \'90px\'); return false"  > ']))
    return outstring


#<area id="1" shape="circle" coords="84,218,70" title="mens.title 1" alt="mens.alt 1" href="#" onClick="fixedtooltip(1, 
#'<a class=\'tip\' href=\'javascript:hidetip(1)\'>X</a> <a class=\'tip2\' 
#href=\'http://simpleidc.bioinfo.cnio.es/nombre1\'>nombre1</a>', this, event, '90px'); return false"  >

def create_div(gene_Names):
    outstring = []
    for numline in range(len(gene_Names)):
        outstring.append(''.join(['document.write(\'<div id="', str(numline + 1),
                            '" class="fixedtipdiv" style="visibility:hidden;width:\'+tipwidth+\';background-color:\'+tipbgcolor+\'" ></div>\') \n']))
    return outstring


out_squeleton1 = """
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Chromosome view</title>
<style type="text/css">

.fixedtipdiv{
position:absolute;
padding: 0px;
border:1px solid blue;
font-family: Verdana,Arial,Helvetica;
font-size: x-small;
font-style: normal;
color:#000000;
line-height:18px; vertical-align:text-top;
z-index:100;
a:link{color: black;}
}

a.tip:link{color: black; text-align:right; vertical-align:top; display:block; padding-bottom:0px; padding-top:0px; font-size: small; text-decoration: none; font-weight: bolder; background-color:#FFFFFF;}
a.tip2:link{color: black; padding-left:4px; padding-bottom:3px;text-decoration: none;}
a.tip2:active{color: black; padding-left:4px;padding-bottom:3px;text-decoration: underline;font-weight: bolder;}
a.tip2:visited{color: red; padding-left:4px;padding-bottom:3px;text-decoration: none;}



</style>

</head>


<body>
<script type="text/javascript">

/**********************************************
*  Original code taken from ToolTip script, by
*  Dynamic Drive (see below). A few changes, additions, and
*  deletions by us (Oscar Rueda Palacio and
*  Ramon Diaz-Uriarte).  A few ideas taken from 
*  overLIB.4.21, by Erik Bosrup.
*
**********************************************/


/***********************************************
* Fixed ToolTip script- copyright (c) Dynamic Drive (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/
        
var tipwidth='150px' //default tooltip width
var tipbgcolor="#CCCCFF"  //tooltip bgcolor
var disappeardelay=250  //tooltip disappear speed onMouseout (in miliseconds)
var vertical_offset="0px" //horizontal offset of tooltip from anchor link
var horizontal_offset="-1px" //horizontal offset of tooltip from anchor link

/////No further editting needed

var ie4=document.all
var ns6=document.getElementById&&!document.all

if (ie4||ns6)
"""

out_squeleton2 = """
function getposOffset(what, offsettype){
var totaloffset=(offsettype=="left")? what.offsetLeft : what.offsetTop;
var parentEl=what.offsetParent;
while (parentEl!=null){
totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
parentEl=parentEl.offsetParent;
}
return totaloffset;
}


function showhide(obj, e, visible, hidden, tipwidth){
if (ie4||ns6)
dropmenuobj.style.left=dropmenuobj.style.top=-500
if (tipwidth!=""){
dropmenuobj.widthobj=dropmenuobj.style
dropmenuobj.widthobj.width=tipwidth
}
if (e.type=="click" && obj.visibility==hidden || e.type=="mouseover")
obj.visibility=visible
else if (e.type=="click")
obj.visibility=visible
}

function iecompattest(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function clearbrowseredge(obj, whichedge){
var edgeoffset=(whichedge=="rightedge")? parseInt(horizontal_offset)*-1 : parseInt(vertical_offset)*-1
if (whichedge=="rightedge"){
var windowedge=ie4 && !window.opera? iecompattest().scrollLeft+iecompattest().clientWidth-15 : window.pageXOffset+window.innerWidth-15
dropmenuobj.contentmeasure=dropmenuobj.offsetWidth
if (windowedge-dropmenuobj.x < dropmenuobj.contentmeasure)
edgeoffset=dropmenuobj.contentmeasure-obj.offsetWidth
}
else{
var windowedge=ie4 && !window.opera? iecompattest().scrollTop+iecompattest().clientHeight-15 : window.pageYOffset+window.innerHeight-18
dropmenuobj.contentmeasure=dropmenuobj.offsetHeight
if (windowedge-dropmenuobj.y < dropmenuobj.contentmeasure)
edgeoffset=dropmenuobj.contentmeasure+obj.offsetHeight
}
return edgeoffset
}

function fixedtooltip(index, menucontents, obj, e, tipwidth){
if (window.event) event.cancelBubble=true
else if (e.stopPropagation) e.stopPropagation()
clearhidetip()
dropmenuobj=document.getElementById? document.getElementById(index) : fixedtipdiv
dropmenuobj.innerHTML=menucontents

if (ie4||ns6){
showhide(dropmenuobj.style, e, "visible", "hidden", tipwidth)
dropmenuobj.x=e.pageX
dropmenuobj.y=e.pageY
dropmenuobj.style.left=dropmenuobj.x-clearbrowseredge(obj, "rightedge")+"px"
dropmenuobj.style.top=dropmenuobj.y-clearbrowseredge(obj, "bottomedge")
}
}

function hidetip(index){
if (typeof dropmenuobj!="undefined"){
if (ie4||ns6)
dropmenuobj=document.getElementById? document.getElementById(index) : fixedtipdiv
dropmenuobj.style.visibility="hidden"
}
}

function delayhidetip(){
if (ie4||ns6)
delayhide=setTimeout("hidetip()",disappeardelay)
}

function clearhidetip(){
if (typeof delayhide!="undefined")
clearTimeout(delayhide)
}

</script>
"""

