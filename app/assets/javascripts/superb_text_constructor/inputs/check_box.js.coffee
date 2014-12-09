window.SuperbTextConstructor or= {}

window.SuperbTextConstructor.CheckBox = class CheckBox extends SuperbTextConstructor.Input
  constructor: (selector) ->
    super
    @input = @el.find('.control-input')

  setHandlers: =>
    $('body').on 'change', "#{@selector}", =>
      @sendRequest()

  contentToData: =>
    data =
      type: @type
    data[@template] = {}
    data[@template][@attribute] = if @input.prop('checked') then '1' else '0'
    data

  dataToContent: (data) =>
    @input.prop('checked', data.block.data[@attribute])

  openEditor: =>
    return

  closeEditor: =>
    return