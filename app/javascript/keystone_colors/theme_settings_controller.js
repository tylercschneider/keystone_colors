import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["accentPicker", "surfacePicker", "accentLabel", "surfaceLabel", "customRadio"]

  selectTemplate(event) {
    const accentHex = event.currentTarget.dataset.accentHex
    const surfaceHex = event.currentTarget.dataset.surfaceHex

    if (this.hasAccentPickerTarget) {
      this.accentPickerTarget.value = accentHex
      this.accentPickerTarget.name = "theme_preference[accent]"
    }
    if (this.hasSurfacePickerTarget) {
      this.surfacePickerTarget.value = surfaceHex
      this.surfacePickerTarget.name = "theme_preference[surface]"
    }
    if (this.hasAccentLabelTarget) this.accentLabelTarget.textContent = accentHex
    if (this.hasSurfaceLabelTarget) this.surfaceLabelTarget.textContent = surfaceHex
  }

  customColorChanged() {
    if (this.hasCustomRadioTarget) {
      this.customRadioTarget.checked = true
    }
    if (this.hasAccentLabelTarget) this.accentLabelTarget.textContent = this.accentPickerTarget.value
    if (this.hasSurfaceLabelTarget) this.surfaceLabelTarget.textContent = this.surfacePickerTarget.value
  }
}
