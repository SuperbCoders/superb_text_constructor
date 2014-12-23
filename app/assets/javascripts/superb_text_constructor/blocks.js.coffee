window.initSingleFileupload = ->
  $('.single-fileupload').each ->
    $(this).fileupload
      type: 'PATCH'
      dropZone: $(this).closest('.dropzone')
      add: (e, data) ->
        data.submit()
      done: (e, data) ->
        $(this).closest('.block').replaceWith(data.result.html)
        $block = $("##{data.result.block.id}")
        $form = $block.find('.form')
        if $form.length
          $form.show()
          $block.find('.content').hide()
        initSingleFileupload()
      fail: (e, data) ->
        alert "Не удалось загрузить файл #{file.name}"

$ ->
  $('.blocks').sortable
    placeholder: "ui-state-highlight"
    handle: '.drag-handle'
    update: (event, ui) ->
      blocks = $('.blocks').sortable('toArray')
      $.post $('.blocks').data('reorder-url'), { blocks: blocks }

  # Create
  $('body').on 'ajax:success', '.new-block', (event, data) ->
    $('#blocks').append(data.html)
    $block = $("##{data.block.id}")
    $form = $block.find('.form')
    if $form.length
      $form.show()
      $block.find('.content').hide()
    initSingleFileupload()

  $('body').on 'ajax:error', '.new-block', (event, data) ->
    alert('Can not create block')

  # Create nested
  $('body').on 'ajax:success', '.new-nested-block', (event, data) ->
    $(this).closest('.nested-blocks').find('.new-nested-block').before(data.html)
    initSingleFileupload()

  $('body').on 'ajax:error', '.new-nested-block', (event, data) ->
    alert('Can not create nested block')

  # Edit
  $('body').on 'click', '.block .edit', (event) ->
    event.preventDefault()
    $block = $(this).closest('.block')
    $form = $block.find('.form')
    if $form.length
      $form.show()
      $block.find('.content').hide()
    false

  # Cancel edit
  $('body').on 'click', '.block .cancel-edit', (event) ->
    event.preventDefault()
    $block = $(this).closest('.block')
    $block.find('.form').hide()
    $block.find('.content').show()
    false

  # Update
  $('body').on 'ajax:success', '.block .block-form', (event, data) ->
    $(this).closest('.block').replaceWith(data.html)
    initSingleFileupload()

  $('body').on 'ajax:error', '.block-form', (event, data) ->
    alert('Can not update block')

  # Destroy
  $('body').on 'ajax:success', '.block .destroy', (event, data) ->
    if data.nested
      $(this).closest('.nested-block').fadeOut()
    else
      $(this).closest('.block').fadeOut()

  initSingleFileupload()