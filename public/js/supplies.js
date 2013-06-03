function checkLayout() {
    var height = $(window).outerHeight();
    var width = $(window).outerWidth();
    if (width <= height) {
        // Portrait Format
        console.log("portrait");
        $('table, td, th').width(width * 0.8);

    }
    else {
        // Landscape Format
        console.log("landscape");
        //$('table, td, th').height(height * 0.8);
        //$('table, td, th').width(width * 1.2);
    }
    console.log("height is: " + height + " width is: " + width);
}

$(window).load(function () {
    checkLayout();
    $(window).resize(function() {
        console.log($(this).height() + "px");
        checkLayout();
    });
});
