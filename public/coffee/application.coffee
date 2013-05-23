ChangeCommit = ($commit)->
  $target_commit = $commit.clone()
  $('.commits-table tr.selected').removeClass 'selected'
  $commit.parents('tr').addClass 'selected'
  $('.show_commit').html $target_commit
  $('.show_commit .diffs li').niceScroll({
    cursorcolor: '#ccc',
    cursorwidth: 14,
  })
  UpdateDiffsWidth()

SetHeight = ->
  commit_offset = $('.show_commit').offset().top
  $('.show_commit').height(window.innerHeight - commit_offset)
  history_offset = $('.history').offset().top
  $('.history').height(window.innerHeight - history_offset)
    
UpdateDiffsWidth = ->
  $('.show_commit .diffs li').each (index)->
    $(this).find('div').css('width', $(this)[0].scrollWidth)

SelectDiff = ->
  $('.show_commit').on 'click', '.diff-names li', (e)->
    $('.show_commit .diff-names .selected').removeClass('selected')
    $(this).addClass('selected')
    if $(this).hasClass('all')
      $('.show_commit .diffs li').removeClass('hidden')
    else
      index = $(this).index() - 1
      $('.show_commit .diffs li').addClass('hidden')
      $('.show_commit .diffs li:eq('+index+')').removeClass('hidden')

ChangeBranch = ($link)->
  timeout = setTimeout ->
    $('.loader').show()
    $('.main').hide()
  , 1500
  $.get $link.attr('href'), (data)->
    clearTimeout(timeout)
    $('.loader').hide()
    $('.current_branch').text ''
    if $link.parents('.ref_label').length
      list_class = $link.parents('.ref_label').attr('data-dropdown-name')
      $('.dropdown.'+list_class+'').parent('.has-dropdown').find('.current_branch').text $link.text()
    else
      $link.parents('.has-dropdown').find('.current_branch').text $link.text()
    $('.commits-table').replaceWith data
    $('.main').show()
    ChangeCommit $('.commits-table tbody tr:first .commit')

SwitchBranch = ->
  $('.top-bar .dropdown li a').on 'click', (e) ->
    e.preventDefault()
    ChangeBranch($(this))
  $('body').on 'click', '.ref_label a', (e) ->
    e.preventDefault()
    ChangeBranch($(this))

RefreshContent = ->
  $('.current_branch').each (index)->
    if $(this).text() != ''
      branch_name = $(this).text()
      $(this).parent('.has-dropdown').find('.dropdown li a').each (index)->
        if $(this).text() == branch_name
          ChangeBranch($(this))
          return false
      return false

SelectRow = ($row) ->
  if $row.offset().top < $('.history').offset().top
    current_scroll = $('.history').scrollTop()
    $('.history').scrollTop(current_scroll + $row.offset().top - $('.history').offset().top)
  offset = $row.offset().top - $('.history').offset().top
  if offset + $row.outerHeight() > $('.history').outerHeight()
    current_scroll = $('.history').scrollTop()
    $('.history').scrollTop(current_scroll + offset + $row.outerHeight() - $('.history').outerHeight())
  ChangeCommit $row.find('.commit')

TableArrows = ->
  motions = [38, 40, 33, 34, 35, 36]
  $('.history').on 'keydown', (e)->
    if motions.indexOf(e.keyCode) == -1
      return
    e.preventDefault()
    e.stopPropagation()
    if e.keyCode == 38 #up
      $next = $('.commits-table tr.selected').prev()
    else if e.keyCode == 40 #down
      $next = $('.commits-table tr.selected').next()
    else if e.keyCode == 33 #page up
      $next_rows = $('.commits-table tr.selected').prevAll()
      if $next_rows.length >= 10
        $next = $next_rows.eq(9)
      else
        $next = $next_rows.last()
    else if e.keyCode == 34 #page down
      $next_rows = $('.commits-table tr.selected').nextAll()
      if $next_rows.length >= 10
        $next = $next_rows.eq(9)
      else
        $next = $next_rows.last()
    else if e.keyCode == 36 #home
      $next = $('.commits-table tbody tr:first')
    else if e.keyCode == 35 #end
      $next = $('.commits-table tr:last')
    if $next and $next.length > 0
      SelectRow($next)

$ ->
  $('.history').on 'click', '.commits-table tr', (e)->
    ChangeCommit $(this).find('.commit')
  $('.refresh').on 'click', (e)->
    e.preventDefault()
    RefreshContent()

  SwitchBranch()
  SetHeight()
  SelectDiff()
  TableArrows()

  $(window).resize ->
    SetHeight()

  $('.show_commit').niceScroll({
    cursorcolor: '#ccc',
    cursorwidth: 14
  })
  $('.history').niceScroll({
    cursorcolor: '#ccc',
    cursorwidth: 14,
    railalign: 'left',
    horizrailenabled: false
  })
  $('.show_commit .diffs li').niceScroll({
    cursorcolor: '#ccc',
    cursorwidth: 14,
  })
  UpdateDiffsWidth()
