var ChangeCommit = function($commit){
    var $target_commit = $commit.clone();
    $('.commits-table tr.selected').removeClass('selected');
    $commit.parents('tr').addClass('selected');
    $('.show_commit').html($target_commit);
}

$(function(){
    $('.top-bar .dropdown li a').on('click', function(e){
        e.preventDefault();
        var $link = $(this);
        $.get($link.attr('href'), function(data){
            $('.current_branch').text($link.text());
            $('.commits-table').replaceWith(data);            
            ChangeCommit($('.commits-table tbody tr:first .commit'));
        });
    })

    $('.history').on('click', '.commits-table tr', function(e){
        ChangeCommit($(this).find('.commit'));
    })
});
