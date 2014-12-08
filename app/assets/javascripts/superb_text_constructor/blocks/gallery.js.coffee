class Gallery
  constructor: (el) ->
    @el = $(el)
    @thumbnails = @el.closest('.thumbnails')
    @initFileupload()

  initFileupload: =>
    @el.fileupload
      dropZone: @el.closest('.dropzone')
      add: (e, data) =>
        @generatePlaceholder(file) for file in data.files
        data.submit()
      done: (e, data) =>
        @generateThumbnail(data)
      fail: (e, data) =>
        alert "Не удалось загрузить файл #{file.name}"

  generatePlaceholder: (file) =>
    @thumbnails.find('.thumbnail.last').closest('.col-md-2').before(@template(file))

  generateThumbnail: (data) =>
    file = data.files[0]

    $image = $('<img>').attr('src', data.result.block[@el.data('field')][@el.data('version')].url)
    $image.load =>
      $placeholder = @thumbnails.find("[data-upload-id=\"#{@uploadId(file)}\"]:visible:first")
      $placeholder.replaceWith(data.result.html)

  uploadId: (file) =>
    "#{file.name}-#{file.size}"

  template: (file) =>
    "<div class=\"col-md-2\" data-upload-id=\"#{@uploadId(file)}\">
      <div class=\"thumbnail nested-block\">
        Loading
      </div>
    </div>"

window.initGalleryFileupload = ->
  $('.gallery-fileupload').each ->
    new Gallery(this)