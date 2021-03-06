window.SuperbTextConstructor or= {}

window.SuperbTextConstructor.TextField = class TextField extends SuperbTextConstructor.Input
  constructor: (selector) ->
    super
    @content = @el.find('.control-content')
    @input = @el.find('.control-input')

  setHandlers: =>
    super

    $('body').on 'focusout', "#{@selector} .control-input", =>
      @sendRequest()

    $('body').on 'keyup', "#{@selector} .control-input", (e) =>
      @sendRequest() if e.keyCode == 13

  contentToData: =>
    data =
      type: @type
    data[@template] = {}
    data[@template][@attribute] = @input.val()
    data

  dataToContent: (data) =>
    newText = data.block.data[@attribute]
    newContent = if newText == '' then '___' else newText
    @content.html(newContent)

  openEditor: =>
    return if @isEdited
    @isEdited = true
    @content.hide()
    @input.show().focus()

  closeEditor: =>
    return unless @isEdited
    @isEdited = false
    @content.show()
    @input.hide()