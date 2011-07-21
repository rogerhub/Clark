(function(){
	$.ajaxSetup({
		cache:false,
		dataType:"text",
		type:"POST"
	});
})();
$(document).ready(function(){
	//I initially did this with automatic generation of the variable strings.. but it was so messy and come on, there's only 5 of them. cut me a break..
	$("#ms_choose_assignpoints").click(function(){
	hideall();
	$("#ms_assignpoints").show();
	});
	$("#ms_choose_volunteerlist").click(function(){
	hideall();
	$("#ms_volunteerlist").show();
	});
	$("#ms_choose_waitlist").click(function(){
	hideall();
	$("#ms_waitlist").show();
	});
	$("#ms_choose_absent").click(function(){
	hideall();
	$("#ms_absentstatus").show();
	});
	$("#ms_choose_cancel").click(function(){
	hideall();
	$("#ms_cancel").show();
	});
	$("#av_submit").click(function(){
		adjustelementbutton(this);
		$.ajax({
			complete:function(jqXHR,textStatus){
				$(this).html("redirecting..");
				location.href="/leadership/managesignups?eventid=" + $("#av_eventid").val();
			},data:{
				eventid:$("#av_eventid").val(),
				"authenticity_token":$('meta[name=csrf-token]').attr('content'),
				accountid:$("#av_accountid").val()
			},url:"/leadership/addvolunteer"
		});
		
	});
});
function hideall(){
	$("#ms_default,#ms_assignpoints,#ms_volunteerlist,#ms_waitlist,#ms_absentstatus,#ms_cancel").hide();
}