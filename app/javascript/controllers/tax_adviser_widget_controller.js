import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "messages"]

  toggle() {
    if (this.panelTarget.classList.contains("d-none")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.panelTarget.classList.remove("d-none")
    this.scrollToBottom()
  }

  close() {
    this.panelTarget.classList.add("d-none")
  }

  scrollToBottom() {
    if (!this.hasMessagesTarget) return
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
