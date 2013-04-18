var ChangeCommit = function($commit){
    var $target_commit = $commit.clone();
    $('table.twelve tr.selected').removeClass('selected');
    $commit.parents('tr').addClass('selected');
    $('.show_commit').html($target_commit);
}

$(function(){
    $('.top-bar .dropdown li a').on('click', function(e){
        e.preventDefault();
        var $link = $(this);
        $.get($link.attr('href'), function(data){
            $('.current_branch').text($link.text());
            $('table.twelve').replaceWith(data);            
            ChangeCommit($('table.twelve tbody tr:first .commit'));
        });
    })

    $('.history').on('click', 'table.twelve tr', function(e){
        ChangeCommit($(this).find('.commit'));
    })
});
