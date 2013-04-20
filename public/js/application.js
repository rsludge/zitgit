var ChangeCommit = function($commit){
    var $target_commit = $commit.clone();
    $('.commits-table tr.selected').removeClass('selected');
    $commit.parents('tr').addClass('selected');
    $('.show_commit').html($target_commit);
    UpdateDiffsWidth();
}

var UpdateDiffsWidth = function(){
    $('.show_commit .diffs li div').each(function(index){
        $(this).css('width', $(this).parent('li')[0].scrollWidth);
    });
}
$(function(){
    $('.top-bar .dropdown li a').on('click', function(e){
        e.preventDefault();
        var $link = $(this);
        $.get($link.attr('href'), function(data){
            $('.current_branch').text('');
            $link.parents('.has-dropdown').find('.current_branch').text($link.text());
            $('.commits-table').replaceWith(data);            
            ChangeCommit($('.commits-table tbody tr:first .commit'));
        });
    })

    $('.history').on('click', '.commits-table tr', function(e){
        ChangeCommit($(this).find('.commit'));
    })
});
