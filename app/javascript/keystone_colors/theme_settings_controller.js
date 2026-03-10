import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["accentPicker", "surfacePicker", "accentLabel", "surfaceLabel", "customRadio", "templateLabel"]

  selectTemplate(event) {
    const input = event.currentTarget
    const label = input.closest("[data-template]")
    const accentHex = input.dataset.accentHex
    const surfaceHex = input.dataset.surfaceHex

    if (this.hasAccentPickerTarget) this.accentPickerTarget.value = accentHex
    if (this.hasSurfacePickerTarget) this.surfacePickerTarget.value = surfaceHex
    if (this.hasAccentLabelTarget) this.accentLabelTarget.textContent = accentHex
    if (this.hasSurfaceLabelTarget) this.surfaceLabelTarget.textContent = surfaceHex

    this.highlightTemplate(label.dataset.template)
  }

  customColorChanged() {
    if (this.hasCustomRadioTarget) this.customRadioTarget.checked = true
    if (this.hasAccentLabelTarget) this.accentLabelTarget.textContent = this.accentPickerTarget.value
    if (this.hasSurfaceLabelTarget) this.surfaceLabelTarget.textContent = this.surfacePickerTarget.value

    this.highlightTemplate("custom")
  }

  highlightTemplate(selected) {
    this.templateLabelTargets.forEach(label => {
      const border = label.querySelector("span")
      if (label.dataset.template === selected) {
        border.classList.remove("border-transparent")
        border.classList.add("border-accent-500")
      } else {
        border.classList.remove("border-accent-500")
        border.classList.add("border-transparent")
      }
    })
  }
}
