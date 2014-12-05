window.initGalleryFileupload = ->
  $('.gallery-fileupload').each ->
    $(this).fileupload
      dropZone: $(this).closest('.dropzone')
      add: (e, data) ->
        generatePlaceholder(this, file) for file in data.files
        data.submit()
      done: (e, data) ->
        generateThumbnail(this, data)
      fail: (e, data) ->
        alert "Не удалось загрузить файл #{file.name}"

template = (file) ->
  "<div class=\"col-md-2\" data-upload-id=\"#{uploadId(file)}\">
    <div class=\"thumbnail nested-block\">
      Loading
    </div>
  </div>"

generatePlaceholder = (gallery, file) ->
  $(gallery).closest('.thumbnails').find('.thumbnail.last').closest('.col-md-2').before(template(file))

generateThumbnail = (gallery, data) ->
  file = data.files[0]
  $image = $('<img>').attr('src', data.result.block.image.square_thumb.url)
  $image.load ->
    $placeholder = $(gallery).closest('.thumbnails').find("[data-upload-id=\"#{uploadId(file)}\"]:visible:first")
    $placeholder.replaceWith(data.result.html)

uploadId = (file) ->
  "#{file.name}-#{file.size}"