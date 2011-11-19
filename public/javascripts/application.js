var clark_window_active = false;
var originalcolor = "#1b2643";
var am,ab;
function hideaccountmenu(){
	am.hide();
	ab.css("background",originalcolor);
}
function showaccountmenu(){
	var pos = ab.offset();
	var height = ab.height();
	am.css( { "left": (pos.left - (am.width() - ab.width()) + 13) + "px", "top":(pos.top + 61) + "px" } ); //13 is the 2x the padding/left/right plus 1px hidden border 61 is the top height
	am.css("display","inline-block");
	if (clark_window_active){
		originalcolor = ab.css("background");
		ab.css("background","#1E4B79");
	} else {
		ab.css("background",originalcolor);
	}
}
$(document).ready(function(){
	am = $("#accountmenu");
	ab = $("#accountbutton");
	ab.live('click',function(){
		if (clark_window_active){
			clark_window_active=false;
			hideaccountmenu();
		} else {
			clark_window_active=true;
			showaccountmenu();
		}
	});
	$(window).resize(function(){
		if (clark_window_active){
			showaccountmenu();
		}
	});
	$(document).click(function(e){
		if (!$(e.target).is("#accountbutton")){
			clark_window_active=false;
			hideaccountmenu();
		}
	});
});
function adjustelementlink(element){
	$(element).click(function(){
		return false;
	}).css({
		color:"#555",
		textDecoration:"none",
		cursor:"text"
	}).html("please wait..");
}
function adjustelementbutton(element){
	$(element).attr("disabled","true").css({
		color:"#555",
		textDecoration:"none",
		cursor:"text"
	}).html("please wait..");
}
function showchooser(a){
	t = $("#"+a);
	t.css("display",(t.css("display")=="none")?"block":"none");
	$("#"+a+" select").chosen();
}