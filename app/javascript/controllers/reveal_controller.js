import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return
        entry.target.classList.add("in")
        this.observer.unobserve(entry.target)
      })
    }, { threshold: 0.15 })

    this.element.querySelectorAll(".reveal").forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    this.observer.disconnect()
  }
}
