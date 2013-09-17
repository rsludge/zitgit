(function() {
  var ChangeBranch, ChangeCommit, CommitArrows, LoadStatus, SelectDiff, SelectRow, SetHeight, ShowAjaxError, ShowAjaxSuccess, ShowCommit, ShowDiff, SwitchBranch, TableArrows, UpdateDiffsWidth, scroll_color;

  scroll_color = '#d7b2b2';

  ShowAjaxSuccess = function(event, xhr) {
    clearTimeout(window.ajax_timeout);
    $('.loader').hide();
    return $('.ajax-error').hide();
  };

  ShowAjaxError = function(event, xhr) {
    clearTimeout(window.ajax_timeout);
    $('.loader').hide();
    return $('.ajax-error').show();
  };

  ChangeCommit = function($commit) {
    var $target_commit;

    $target_commit = $commit.clone();
    $('.commits-table tr.selected').removeClass('selected');
    $('.status').removeClass('selected');
    $commit.parents('tr').addClass('selected');
    $('.show_commit').html($target_commit);
    $('.show_commit .diffs li').niceScroll({
      cursorcolor: scroll_color,
      cursorwidth: 14
    });
    return UpdateDiffsWidth();
  };

  LoadStatus = function() {
    var $status_content;

    $('.commits-table tr.selected').removeClass('selected');
    $('.status').addClass('selected');
    $status_content = $('.status .status_content').clone();
    $('.show_commit').html($status_content);
    $('.show_commit .diffs li').niceScroll({
      cursorcolor: scroll_color,
      cursorwidth: 14
    });
    return UpdateDiffsWidth();
  };

  SetHeight = function() {
    var commit_offset, history_offset;

    commit_offset = $('.show_commit').offset().top;
    $('.show_commit').height(window.innerHeight - commit_offset);
    history_offset = $('.history').offset().top;
    return $('.history').height(window.innerHeight - history_offset);
  };

  UpdateDiffsWidth = function() {
    return $('.show_commit .diffs li').each(function(index) {
      return $(this).find('div').css('width', $(this)[0].scrollWidth);
    });
  };

  SelectDiff = function($diff) {
    var index;

    $('.show_commit .diff-names .selected').removeClass('selected');
    $diff.addClass('selected');
    if ($diff.hasClass('all')) {
      $('.show_commit .diffs li').removeClass('hidden');
    } else {
      index = $diff.index() - 1;
      $('.show_commit .diffs li').addClass('hidden');
      $('.show_commit .diffs li:eq(' + index + ')').removeClass('hidden');
    }
    return UpdateDiffsWidth();
  };

  ChangeBranch = function($link) {
    window.ajax_timeout = setTimeout(function() {
      $('.loader').show();
      return $('.main').hide();
    }, 1500);
    return $.get($link.attr('href'), function(data) {
      var list_class;

      $('.current_branch').text('');
      if ($link.parents('.ref_label').length) {
        list_class = $link.parents('.ref_label').attr('data-dropdown-name');
        $('.dropdown.' + list_class + '').parent('.has-dropdown').find('.current_branch').text($link.text());
      } else {
        $link.parents('.has-dropdown').find('.current_branch').text($link.text());
      }
      $('.commits-table').replaceWith(data);
      $('.main').show();
      return ChangeCommit($('.commits-table tbody tr:first .commit'));
    });
  };

  SwitchBranch = function() {
    $('.top-bar .dropdown li a').on('click', function(e) {
      e.preventDefault();
      return ChangeBranch($(this));
    });
    return $('body').on('click', '.ref_label a', function(e) {
      e.preventDefault();
      return ChangeBranch($(this));
    });
  };

  SelectRow = function($row) {
    var current_scroll, offset;

    if ($row.offset().top < $('.history').offset().top) {
      current_scroll = $('.history').scrollTop();
      $('.history').scrollTop(current_scroll + $row.offset().top - $('.history').offset().top);
    }
    offset = $row.offset().top - $('.history').offset().top;
    if (offset + $row.outerHeight() > $('.history').outerHeight()) {
      current_scroll = $('.history').scrollTop();
      $('.history').scrollTop(current_scroll + offset + $row.outerHeight() - $('.history').outerHeight());
    }
    return ChangeCommit($row.find('.commit'));
  };

  TableArrows = function() {
    var motions;

    motions = [38, 40, 33, 34, 35, 36];
    return $('.history').on('keydown', function(e) {
      var $next, $next_rows;

      if (motions.indexOf(e.keyCode) === -1) {
        return;
      }
      e.preventDefault();
      e.stopPropagation();
      if (e.keyCode === 38) {
        $next = $('.commits-table tr.selected').prev();
      } else if (e.keyCode === 40) {
        $next = $('.commits-table tr.selected').next();
      } else if (e.keyCode === 33) {
        $next_rows = $('.commits-table tr.selected').prevAll();
        if ($next_rows.length >= 10) {
          $next = $next_rows.eq(9);
        } else {
          $next = $next_rows.last();
        }
      } else if (e.keyCode === 34) {
        $next_rows = $('.commits-table tr.selected').nextAll();
        if ($next_rows.length >= 10) {
          $next = $next_rows.eq(9);
        } else {
          $next = $next_rows.last();
        }
      } else if (e.keyCode === 36) {
        $next = $('.commits-table tbody tr:first');
      } else if (e.keyCode === 35) {
        $next = $('.commits-table tr:last');
      }
      if ($next && $next.length > 0) {
        return SelectRow($next);
      }
    });
  };

  CommitArrows = function() {
    var motions;

    motions = [38, 40];
    return $('.show_commit').on('keydown', function(e) {
      var $next;

      if (motions.indexOf(e.keyCode) === -1) {
        return;
      }
      e.preventDefault();
      e.stopPropagation();
      if (e.keyCode === 38) {
        $next = $('.show_commit .diff-names li.selected').prev();
      } else if (e.keyCode === 40) {
        $next = $('.show_commit .diff-names li.selected').next();
      }
      if ($next && $next.length > 0) {
        return SelectDiff($next);
      }
    });
  };

  ShowDiff = function() {
    return $('body').on('click', '.show_diff a', function(e) {
      var $container, $link;

      e.preventDefault();
      $link = $(this);
      $container = $link.parents('.show_commit');
      $link.hide();
      $container.find('.loading').show();
      return $.get($link.attr('href'), function(data) {
        $container.find('.loading').hide();
        $link.parents('li').html(data);
        $('.show_commit .diffs li').niceScroll({
          cursorcolor: scroll_color,
          cursorwidth: 14
        });
        return UpdateDiffsWidth();
      });
    });
  };

  ShowCommit = function() {
    return $('body').on('click', 'a.large', function(e) {
      var $container, $link;

      e.preventDefault();
      $link = $(this);
      $container = $link.parents('.show_commit');
      $link.hide();
      $container.find('.loading').show();
      return $.get($link.attr('href'), function(data) {
        $link.parents('.diff-names').replaceWith(data);
        $('.show_commit .diffs li').niceScroll({
          cursorcolor: scroll_color,
          cursorwidth: 14
        });
        return UpdateDiffsWidth();
      });
    });
  };

  $(function() {
    window.ajax_timeout = 0;
    $(document).ajaxError(ShowAjaxError);
    $(document).ajaxSuccess(ShowAjaxSuccess);
    $('.history').on('click', '.commits-table tr', function(e) {
      return ChangeCommit($(this).find('.commit'));
    });
    $('.history').on('click', '.status-link', function(e) {
      e.preventDefault();
      return LoadStatus();
    });
    $('.show_commit').on('click', '.diff-names li', function(e) {
      return SelectDiff($(this));
    });
    SwitchBranch();
    SetHeight();
    TableArrows();
    CommitArrows();
    ShowDiff();
    ShowCommit();
    $(window).resize(function() {
      return SetHeight();
    });
    $('.show_commit').niceScroll({
      cursorcolor: scroll_color,
      cursorwidth: 14
    });
    $('.history').niceScroll({
      cursorcolor: scroll_color,
      cursorwidth: 14,
      railalign: 'left',
      horizrailenabled: false
    });
    $('.show_commit .diffs li').niceScroll({
      cursorcolor: scroll_color,
      cursorwidth: 14
    });
    return UpdateDiffsWidth();
  });

}).call(this);
