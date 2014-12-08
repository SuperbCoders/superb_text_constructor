// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require ./jquery-ui.min
//= require ./bootstrap-sprockets
//= require ./blocks
//= require_tree ./blocks
//= require_tree ./inputs

$(document).bind('dragover', function (e)
{
  var dropZone = $('.dropzone'),
      foundDropzone,
      timeout = window.dropZoneTimeout;
      if (!timeout)
      {
          dropZone.addClass('in');
      }
      else
      {
          clearTimeout(timeout);
      }
      var found = false,
      node = e.target;

      do{

          if ($(node).hasClass('dropzone'))
          {
              found = true;
              foundDropzone = $(node);
              break;
          }

          node = node.parentNode;

      }while (node != null);

      dropZone.removeClass('in hover');

      if (found)
      {
          foundDropzone.addClass('hover');
      }

      window.dropZoneTimeout = setTimeout(function ()
      {
          window.dropZoneTimeout = null;
          dropZone.removeClass('in hover');
      }, 100);
});