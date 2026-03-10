import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["accent", "surface"]

  selectTemplate(event) {
    const accent = event.currentTarget.dataset.accent
    const surface = event.currentTarget.dataset.surface

    this.checkRadio(this.accentTargets, accent)
    this.checkRadio(this.surfaceTargets, surface)
  }

  checkRadio(targets, value) {
    targets.forEach(radio => {
      radio.checked = radio.value === value
      radio.dispatchEvent(new Event("change", { bubbles: true }))
    })
  }
}
