$(document).ready(function(){
	$("#login_studentid").focus();
	$("#login_password").keypress(function(e) {
        if(e.which == 13) {
			$("#login_button").trigger("click");
		}
	});
	$("#login_button").click(function(){
		$("#sl_studentid").val($("#login_studentid").val());
		$("#sl_challenge").val(auth_challenge);
		$("#sl_challengehash").val(auth_challengehash);
		var subhash = hex_sha512($("#login_password").val() + levelone);
		var superhash = hex_sha512(subhash + auth_challenge);
		$("#sl_superhash").val(superhash);
		$("#sl_form").submit();		
	});
});