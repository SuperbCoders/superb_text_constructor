window.SuperbTextConstructor or= {}

window.SuperbTextConstructor.Input = class Input
  constructor: (@selector) ->
    @el = $(selector)
    @url = @el.data('url')
    @attribute = @el.data('attribute')
    @template = @el.data('template')
    @type = @el.data('type')

    @isEdited = false

    @setHandlers()

  setHandlers: =>
    $('body').on 'click', @selector, =>
      @openEditor()

  contentToData: =>
    console.log 'Implement me!'
    {}

  dataToContent: (data) =>
    console.log 'Implement me!'

  openEditor: =>
    console.log 'Implement me!'

  closeEditor: =>
    console.log 'Implement me!'

  sendRequest: =>
    $.ajax
      method: 'PATCH'
      url: @url
      data: @contentToData()
      success: (response, textStatus, jqXhr) =>
        @dataToContent(response)
        @closeEditor()
      error: (response, textStatus, jqXhr) =>
        alert 'Something went wrong! Check for details in console.'
        console.log response