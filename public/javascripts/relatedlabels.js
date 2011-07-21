//deprecated
function relatedlabels(input,target,tumblrurl){
	$(target).html("<p>Communicating with tumblr...</p>");
	$.ajax({
		cache:true,
		dataType:"text",
		type:"GET",
		failure:function(jqXHR,textStatus,errorThrown){
			$(target).html("<p>Tumblr communication error (" + errorThrown + ")</p>");			
		},
		success:function(data,textStatus,jqXHR){
			$(target).html("");
			eval(jqXHR.responseText); //OH NO DANGER!! LOL
			if (tumblr_api_read.posts.length == 0){
				$(target).html('<p>Nothing on the blog mentions this volunteer.</p>');
			} else {
				var ftext = "<ul>";
				$.each(tumblr_api_read.posts,function(a,b){
					ftext += '<li><a href="' + b['url-with-slug'] + '">' + b.slug + '</a></li>';
				});
				ftext += "</ul>";
				$(target).html(ftext);
			}
		},data:{
			tagged:input
		},url:"http://"+tumblrurl+".tumblr.com/api/read/json"
	});
}