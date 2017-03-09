#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require nprogress
#= require nprogress-turbolinks
#= require tether
#= require bootstrap-sprockets
#= require better-dom
#= require better-i18n-plugin
#= require better-popover-plugin
#= require better-form-validation
#= require better-form-validation/i18n/better-form-validation.ru
#= require moment
#= require bootstrap-datetimepicker
#= require pickers
#= require select2
#= require_tree .

DOM.set("lang", "ru")

NProgress.configure
  showSpinner: false
  ease: 'ease'
  speed: 500


document.addEventListener "turbolinks:load", ->
  console.log "turbolinks:load"
  $("select[data-accounts]").select2
    ajax:
      url: '/accounts/suggestions'
      cache: true
      data: (params) ->
        return {
          q: params.term
          page: params.page
        }
      processResults: (data, params) ->
        #// parse the results into the format expected by Select2
        #// since we are using custom formatting functions we do not need to
        #// alter the remote JSON data, except to indicate that infinite
        #// scrolling can be used
        params.page = params.page || 1

        return {
          results: data.items,
          pagination: {
            more: (params.page * 30) < data.total_count
          }
        }
