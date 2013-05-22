(function() {
  var ChangeBranch, ChangeCommit, RefreshContent, SelectDiff, SetHeight, SwitchBranch, TableArrows, UpdateDiffsWidth;

  ChangeCommit = function($commit) {
    var $target_commit;

    $target_commit = $commit.clone();
    $('.commits-table tr.selected').removeClass('selected');
    $commit.parents('tr').addClass('selected');
    $('.show_commit').html($target_commit);
    $('.show_commit .diffs li').niceScroll({
      cursorcolor: '#ccc',
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

  SelectDiff = function() {
    return $('.show_commit').on('click', '.diff-names li', function(e) {
      var index;

      $('.show_commit .diff-names .selected').removeClass('selected');
      $(this).addClass('selected');
      if ($(this).hasClass('all')) {
        return $('.show_commit .diffs li').removeClass('hidden');
      } else {
        index = $(this).index() - 1;
        $('.show_commit .diffs li').addClass('hidden');
        return $('.show_commit .diffs li:eq(' + index + ')').removeClass('hidden');
      }
    });
  };

  ChangeBranch = function($link) {
    var timeout;

    timeout = setTimeout(function() {
      $('.loader').show();
      return $('.main').hide();
    }, 1500);
    return $.get($link.attr('href'), function(data) {
      var list_class;

      clearTimeout(timeout);
      $('.loader').hide();
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

  RefreshContent = function() {
    return $('.current_branch').each(function(index) {
      var branch_name;

      if ($(this).text() !== '') {
        branch_name = $(this).text();
        $(this).parent('.has-dropdown').find('.dropdown li a').each(function(index) {
          if ($(this).text() === branch_name) {
            ChangeBranch($(this));
            return false;
          }
        });
        return false;
      }
    });
  };

  TableArrows = function() {
    var motions;

    motions = [38, 40];
    return $('.history').on('keydown', function(e) {
      var $next;

      if (motions.indexOf(e.keyCode) === -1) {
        return;
      }
      if (e.keyCode === 38) {
        e.preventDefault();
        e.stopPropagation();
        $next = $('.commits-table tr.selected').prev();
      } else if (e.keyCode === 40) {
        e.preventDefault();
        e.stopPropagation();
        $next = $('.commits-table tr.selected').next();
      }
      if ($next && $next.length > 0) {
        return ChangeCommit($next.find('.commit'));
      }
    });
  };

  $(function() {
    $('.history').on('click', '.commits-table tr', function(e) {
      return ChangeCommit($(this).find('.commit'));
    });
    $('.refresh').on('click', function(e) {
      e.preventDefault();
      return RefreshContent();
    });
    SwitchBranch();
    SetHeight();
    SelectDiff();
    TableArrows();
    $(window).resize(function() {
      return SetHeight();
    });
    $('.show_commit').niceScroll({
      cursorcolor: '#ccc',
      cursorwidth: 14
    });
    $('.history').niceScroll({
      cursorcolor: '#ccc',
      cursorwidth: 14,
      railalign: 'left',
      horizrailenabled: false
    });
    $('.show_commit .diffs li').niceScroll({
      cursorcolor: '#ccc',
      cursorwidth: 14
    });
    return UpdateDiffsWidth();
  });

}).call(this);
