function checkLayout() {
    var height = $(window).height();
    var width = $(window).width();
    //var $viewport = $('head').children('meta[name="viewport"]');
    if (width > height) {
        // Landscape Format
        //$viewport.attr('content', 'height=device-width,width=device-height,initial-scale=1.0,maximum-scale=1.0');
	$('.checkbox, .radio').css({
            "margin":"10px"
        });
        $('input, label').css({
            "float":"left"
        });
        $('fieldset').css({
            "border":"1px solid black"
        });
    }
    else {
        // Portrait Format
	//$viewport.attr('content', 'height=device-height,width=device-width,initial-scale=1.0,maximum-scale=1.0');
        $('input, label').css({
            "float":"none"
        });
        $('.checkbox, .radio').css({
            "margin":"0px"
        });
        $('fieldset').css({
            "border":"0"
        });
    }
}

$(document).ready(function () {
    $(window).load(function() {
        checkLayout();
    });
    $(window).resize(function() {
        checkLayout();
    });
});
