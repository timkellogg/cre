$(document).ready(function() {   
    
    // Allows for CSS manipulation of svg assets      
        $('img.svg').each(function(){
            var $img = jQuery(this);
            var imgID = $img.attr('id');
            var imgClass = $img.attr('class');
            var imgURL = $img.attr('src');

            $.get(imgURL, function(data) {
                // Get the SVG tag, ignore the rest
                var $svg = jQuery(data).find('svg');

                // Add replaced image's ID to the new SVG
                if(typeof imgID !== 'undefined') {
                    $svg = $svg.attr('id', imgID);
                }
                // Add replaced image's classes to the new SVG
                if(typeof imgClass !== 'undefined') {
                    $svg = $svg.attr('class', imgClass+' replaced-svg');
                }

                // Remove any invalid XML tags as per http://validator.w3.org
                $svg = $svg.removeAttr('xmlns:a');

                // Replace image with new SVG
                $img.replaceWith($svg);

            }, 'xml');

        });

    // Tooltips 
    $(function () {
        $('#cr_pages').tooltip();
        $('#bioguide_id').tooltip();
        $('#title').tooltip();
        $('#fec_id').tooltip();
    });

    // Animations 
    setTimeout(function() {
        $('.img-fade').fadeTo('slow', 1);
    }, 500 );

    setTimeout(function() {
        $('#word-spin').text('Discover').css('background-color', 'lightyellow');
    }, 1000 );

    setTimeout(function() {
        $('#word-spin').text('Contribute');
    }, 1500 );

    setTimeout(function() {
        $('#word-spin').text('Learn');
    }, 2000 );

    setTimeout(function() {
        $('#word-spin').text('Grow');
    }, 2500 );

    setTimeout(function() {
        $('#word-spin').text('Research');
    }, 3000 );

    // Search/filtering 
    
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