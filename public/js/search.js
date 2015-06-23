$(document).ready(function() {

	// when data is a list 
	$('#search-term').keyup(function(event) {
		$('ul').show(); // textsearch

		var query = event.target.value;
		var selector = "ul:contains(" + query + ")";

		$('ul').not(selector).hide();
	});

	// when data is tabular 
	$('#search-term').keyup(function(event) {
		$('table').show();

		var query = event.target.value;
		var selector = "table:contains(" + query + ")";

		$('table').not(selector).hide();
	});

});	