$(document).ready(function(){
	$("#googgo").live('click',function(){
		location.href="http://google.com/search?q=" + encodeURIComponent($("#googsearch").val()) + "%20site:walnutnhs.com";		
	});
	$("#bloggooggo").live('click',function(){
		location.href="http://google.com/search?q=" + encodeURIComponent($("#bloggoogsearch").val()) + "%20site:blog.walnutnhs.com";		
	});
});