ChangeCommit = ($commit)->
    $target_commit = $commit.clone()
    $('.commits-table tr.selected').removeClass 'selected'
    $commit.parents('tr').addClass 'selected'
    $('.show_commit').html $target_commit
    UpdateDiffsWidth()
    
UpdateDiffsWidth = ->
    $('.show_commit .diffs li').each (index)->
        $(this).find('div').css('width', $(this)[0].scrollWidth)

$ ->
  $('.top-bar .dropdown li a').on 'click', (e) ->
    e.preventDefault()
    $link = $(this)
    $.get $link.attr('href'), (data)->
      $('.current_branch').text ''
      $link.parents('.has-dropdown').find('.current_branch').text $link.text()
      $('.commits-table').replaceWith data
      ChangeCommit $('.commits-table tbody tr:first .commit')

  $('.history').on 'click', '.commits-table tr', (e)->
    ChangeCommit $(this).find('.commit')

  UpdateDiffsWidth()
