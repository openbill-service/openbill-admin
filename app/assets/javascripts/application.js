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
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require tether
//= require bootstrap-sprockets
//= require better-dom
//= require better-i18n-plugin
//= require better-popover-plugin
//= require better-form-validation
//= require better-form-validation/i18n/better-form-validation.ru
//= require moment
//= require bootstrap-datetimepicker
//= require pickers
//= require select2
//= require_tree .

DOM.set("lang", "ru")

NProgress.configure({
  showSpinner: false,
  ease: 'ease',
  speed: 500
});
$(function() {
  $("select[id$=from_account_id], select[id$=to_account_id]").select2();
});

