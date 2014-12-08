window.SuperbTextConstructor or= {}

window.SuperbTextConstructor.TextArea = class TextArea extends SuperbTextConstructor.Input
  constructor: (selector) ->
    super

  setHandlers: =>
    super
    $('body').on 'focusout', "#{@selector}", =>
      @sendRequest()

  contentToData: =>
    data =
      type: @type
    data[@template] = {}
    data[@template][@attribute] = @el.html()
    data

  dataToContent: (data) =>
    @el.html(data.block.data[@attribute])

  openEditor: =>
    return if @isEdited
    @isEdited = true
    @el.attr(contenteditable: true).focus()

  closeEditor: =>
    return unless @isEdited
    @isEdited = false
    @el.attr(contenteditable: false)