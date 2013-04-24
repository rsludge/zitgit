(function() {
  var ChangeCommit, UpdateDiffsWidth;

  ChangeCommit = function($commit) {
    var $target_commit;

    $target_commit = $commit.clone();
    $('.commits-table tr.selected').removeClass('selected');
    $commit.parents('tr').addClass('selected');
    $('.show_commit').html($target_commit);
    return UpdateDiffsWidth();
  };

  UpdateDiffsWidth = function() {
    return $('.show_commit .diffs li').each(function(index) {
      return $(this).find('div').css('width', $(this)[0].scrollWidth);
    });
  };

  $(function() {
    $('.top-bar .dropdown li a').on('click', function(e) {
      var $link, timeout;

      e.preventDefault();
      $link = $(this);
      timeout = setTimeout(function() {
        $('.loader').show();
        return $('.main').hide();
      }, 1500);
      return $.get($link.attr('href'), function(data) {
        clearTimeout(timeout);
        $('.loader').hide();
        $('.current_branch').text('');
        $link.parents('.has-dropdown').find('.current_branch').text($link.text());
        $('.commits-table').replaceWith(data);
        $('.main').show();
        return ChangeCommit($('.commits-table tbody tr:first .commit'));
      });
    });
    $('.history').on('click', '.commits-table tr', function(e) {
      return ChangeCommit($(this).find('.commit'));
    });
    return UpdateDiffsWidth();
  });

}).call(this);
