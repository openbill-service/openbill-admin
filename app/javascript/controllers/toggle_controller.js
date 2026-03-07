import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = { open: { type: Boolean, default: false } }

  toggle() {
    this.openValue = !this.openValue
  }

  openValueChanged() {
    this.contentTargets.forEach((el) => {
      el.classList.toggle("hidden", !this.openValue)
    })

    this.element.querySelectorAll("[data-action*='toggle#toggle']").forEach((trigger) => {
      trigger.setAttribute("aria-expanded", this.openValue)
    })
  }
}
