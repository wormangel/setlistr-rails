// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require noty
//= require js-routes
//= require routes
//= require bootstrap-datepicker
//= require jquery-timepicker-jt

// Common code for all pages

$(document).on('page:load ready', function() {
  displayFlash = function(msg, type) {
    n = noty({
      text: msg,
      animation: {
        open: 'animated fadeIn',
        close: 'animated fadeOut'
      },
      timeout: 3000,
      type: type,
      layout: 'topCenter'
    });
  };
  
  flash_alert = $('#flash-alert-msg').attr('value');
  if (flash_alert && flash_alert !== '') {
    displayFlash(flash_alert, 'error');
  }
  
  flash_notice = $('#flash-notice-msg').attr('value');
  if (flash_notice && flash_notice !== '') {
    displayFlash(flash_notice, 'success');
  }
});