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
//= require jqueryui
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require noty
//= require js-routes
//= require routes
//= require bootstrap-datepicker
//= require jquery-timepicker-jt
//= require sprintf

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
  
  findBootstrapEnvironment = function() {
    var envs = ['xs', 'sm', 'md', 'lg'];

    var $el = $('<div>');
    $el.appendTo($('body'));

    for (var i = envs.length - 1; i >= 0; i--) {
      var env = envs[i];

      $el.addClass('hidden-'+env);
      if ($el.is(':hidden')) {
          $el.remove();
          return env;
      }
    }
  }
  
  startSpinner = function() {
    $("html").css("cursor", "progress");
  }
  
  stopSpinner = function() {
    $("html").css("cursor", "auto");
  }

  seconds_to_hms = function(seconds) {
    seconds = parseInt(seconds);
    if (seconds < 60) {
      return seconds + 's';
    }
    else if (seconds < 3600) {
      if (seconds % 60 == 0) {
        return Math.floor(seconds/60) + 'min';
      } else {
        return Math.floor(seconds/60) + 'min' + sprintf("%02d", (seconds%60)) + 's';
      }
    } else {
      if (seconds % 3600 == 0) {
        return Math.floor(seconds/3600)+ 'h';
      } else {
        if (Math.floor(seconds/3600) % 60 == 0) {
          return Math.floor(seconds/3600) + 'h' + sprintf("%02d", Math.floor((seconds%3600) / 60)) + 'min';
        } else {
          return Math.floor(seconds/3600) + 'h' + sprintf("%02d", Math.floor((seconds%3600) / 60)) + 'min' + sprintf("%02d", ( (seconds%3600) % 60 )) + 's';
        }
      }
    }
  }
  
  $(document).on("page:fetch", startSpinner);
  $(document).on("page:receive", stopSpinner);
});

// Helper for sorting JSON
/*** Copyright 2013 Teun Duynstee Licensed under the Apache License, Version 2.0 ***/
firstBy=function(){function n(n,t){if("function"!=typeof n){var r=n;n=function(n,t){return n[r]<t[r]?-1:n[r]>t[r]?1:0}}if(1===n.length){var u=n;n=function(n,t){return u(n)<u(t)?-1:u(n)>u(t)?1:0}}return-1===t?function(t,r){return-n(t,r)}:n}function t(t,u){return t=n(t,u),t.thenBy=r,t}function r(r,u){var f=this;return r=n(r,u),t(function(n,t){return f(n,t)||r(n,t)})}return t}();