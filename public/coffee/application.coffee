ChangeCommit = ($commit)->
  $target_commit = $commit.clone()
  $('.commits-table tr.selected').removeClass 'selected'
  $commit.parents('tr').addClass 'selected'
  $('.show_commit').html $target_commit
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

$ ->
  $('.top-bar .dropdown li a').on 'click', (e) ->
    e.preventDefault()
    $link = $(this)
    timeout = setTimeout ->
      $('.loader').show()
      $('.main').hide()
    , 1500
    $.get $link.attr('href'), (data)->
      clearTimeout(timeout)
      $('.loader').hide()
      $('.current_branch').text ''
      $link.parents('.has-dropdown').find('.current_branch').text $link.text()
      $('.commits-table').replaceWith data
      $('.main').show()
      ChangeCommit $('.commits-table tbody tr:first .commit')

  $('.history').on 'click', '.commits-table tr', (e)->
    ChangeCommit $(this).find('.commit')

  UpdateDiffsWidth()
  SetHeight()
  SelectDiff()

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
  $('.diffs li').niceScroll({
    cursorcolor: '#ccc',
    cursorwidth: 14,
  })
