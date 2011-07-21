(function(){
	$.ajaxSetup({
		cache:false,
		dataType:"text",
		type:"POST"
	});
})();
function post_signup(eid,e){
	adjustelementlink(e);
	$.ajax({
		complete:function(jqXHR,textStatus){
			$(e).html("redirecting..");
			location.href=location.href;
		},data:{
			event_id:eid,
			"authenticity_token":$('meta[name=csrf-token]').attr('content')
		},url:"/volunteer/signup/"
	});
}
function post_cancel(eid,e){
	adjustelementlink(e);
	$.ajax({
		complete:function(jqXHR,textStatus){
			$(e).html("redirecting..");
			location.href=location.href;
		},data:{
			event_id:eid,
			"authenticity_token":$('meta[name=csrf-token]').attr('content')
		},url:"/volunteer/cancel/"
	});
}
function showreplier(a){
	$("#replier-"+a).css("display","block");
}
function hidereplier(a){
	$("#replier-"+a).css("display","none");	
}
function showeditor(a){
	$("#editor-"+a).css("display","block");
}
function hideeditor(a){
	$("#editor-"+a).css("display","none");	
}