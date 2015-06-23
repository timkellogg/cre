$(document).ready(function() {

	$('#search-term').keyup(function(event) {
		$('ul').show();

		var query = event.target.value;
		var selector = "ul:contains(" + query + ")";

		$('ul').not(selector).hide();
	});
	
});	