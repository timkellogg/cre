$(document).ready(function() {

	// solution: you should have the button labled "search" that applies to all pages
	// you should have a input labled "search-term" that can apply to all pages 

	// finally, have an id of look-up/whatever that you assign to the DOM element you want to search
	// this way, you only have one javascript file for all searches 

	$('#search-btn').on('click', function() {

		var q = $('#search-term').val();

		var first = $('.searchable')[0];
		
		console.log(first.innerHTML);
		var q = "";
	});


});