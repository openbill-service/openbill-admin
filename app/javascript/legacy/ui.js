const jquery = () => window.jQuery || window.$

const initTooltipsAndPopovers = () => {
  const $ = jquery()
  if (!$) return

  $("[data-bs-toggle='tooltip'], [data-toggle='tooltip']").each((_, element) => {
    // Works with Bootstrap 5 API.
    if (window.bootstrap?.Tooltip) {
      window.bootstrap.Tooltip.getOrCreateInstance(element)
    }
  })

  $("[data-bs-toggle='popover'], [data-toggle='popover']").each((_, element) => {
    if (window.bootstrap?.Popover) {
      window.bootstrap.Popover.getOrCreateInstance(element)
    }
  })
}

const initAccountSelect2 = () => {
  const $ = jquery()
  if (!$) return

  const accounts = $("select[data-accounts]")
  if (!accounts.length || typeof accounts.select2 !== "function") return

  accounts.select2({
    ajax: {
      url: "/accounts/suggestions",
      cache: true,
      data: (params) => ({
        q: params.term,
        page: params.page
      }),
      processResults: (data, params) => {
        const page = params.page || 1
        return {
          results: data.items,
          pagination: {
            more: page * 30 < data.total_count
          }
        }
      }
    }
  })
}

document.addEventListener("turbo:load", () => {
  initTooltipsAndPopovers()
  initAccountSelect2()
})
