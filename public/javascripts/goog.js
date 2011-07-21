$(document).ready(function(){
	$("#googgo").live('click',function(){
		location.href="http://google.com/search?q=" + encodeURIComponent($("#googsearch").val()) + "%20site:walnutnhs.com";		
	});
});