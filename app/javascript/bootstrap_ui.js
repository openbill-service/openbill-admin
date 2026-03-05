const initTooltipsAndPopovers = () => {
  document
    .querySelectorAll("[data-bs-toggle='tooltip']")
    .forEach((element) => window.bootstrap?.Tooltip?.getOrCreateInstance(element))

  document
    .querySelectorAll("[data-bs-toggle='popover']")
    .forEach((element) => window.bootstrap?.Popover?.getOrCreateInstance(element))
}

document.addEventListener("turbo:load", () => {
  initTooltipsAndPopovers()
})
