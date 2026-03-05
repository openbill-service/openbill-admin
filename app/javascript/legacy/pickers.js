const jquery = () => window.jQuery || window.$

const initDateTimePickers = () => {
  const $ = jquery()
  if (!$) return

  if (typeof $.fn.datetimepicker !== "function") return

  $(".datetimepicker").datetimepicker({
    ignoreReadonly: true,
    icons: {
      date: "fa fa-calendar",
      time: "fa fa-clock-o",
      up: "fa fa-chevron-up",
      down: "fa fa-chevron-down",
      previous: "fa fa-chevron-left",
      next: "fa fa-chevron-right",
      today: "fa fa-crosshairs",
      clear: "fa fa-trash-o",
      close: "fa fa-times"
    }
  })

  $(".datetimerange").each((_, container) => {
    const $container = $(container)
    const range1 = $($container.find(".input-group")[0])
    const range2 = $($container.find(".input-group")[1])

    if (range1.data("DateTimePicker")?.date() != null) {
      range2.data("DateTimePicker").minDate(range1.data("DateTimePicker").date())
    }

    if (range2.data("DateTimePicker")?.date() != null) {
      range1.data("DateTimePicker").maxDate(range2.data("DateTimePicker").date())
    }

    range1.on("dp.change", (e) => {
      if (e.date) {
        range2.data("DateTimePicker").minDate(e.date)
      } else {
        range2.data("DateTimePicker").minDate(false)
      }
    })

    range2.on("dp.change", (e) => {
      if (e.date) {
        range1.data("DateTimePicker").maxDate(e.date)
      } else {
        range1.data("DateTimePicker").maxDate(false)
      }
    })
  })
}

document.addEventListener("turbo:load", () => {
  initDateTimePickers()
})
