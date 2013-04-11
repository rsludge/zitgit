$(function(){
    $('.top-bar .dropdown li a').on('click', function(e){
        e.preventDefault();
        var $link = $(this);
        $.get($link.attr('href'), function(data){
            $('.current_branch').text($link.text());
            $('table.twelve').replaceWith(data);
        });
    })
});
