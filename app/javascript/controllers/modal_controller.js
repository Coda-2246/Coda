import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  hideOnSuccess(event) {
    if (event.detail.success) window.bootstrap.Modal.getOrCreateInstance(this.element).hide()
  }
}
