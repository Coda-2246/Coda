import { Controller } from "@hotwired/stimulus"

const NEW_GIG_VALUE = "__new_gig__"

export default class extends Controller {
  connect() {
    this.previousValue = this.element.value

    const option = document.createElement("option")
    option.id = "new_gig_option"
    option.value = NEW_GIG_VALUE
    option.textContent = "+ Add new gig…"
    this.element.appendChild(option)

    if (this.element.value === NEW_GIG_VALUE) {
      window.bootstrap.Modal.getOrCreateInstance(document.getElementById("newGigModal")).show()
    }
  }

  change() {
    if (this.element.value === NEW_GIG_VALUE) {
      this.element.value = this.previousValue
      window.bootstrap.Modal.getOrCreateInstance(document.getElementById("newGigModal")).show()
    } else {
      this.previousValue = this.element.value
    }
  }
}
