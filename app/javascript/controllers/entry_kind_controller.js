import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["kind", "categoryWrapper", "categorySelect"]

  connect() {
    this.toggleCategory()
  }

  toggleCategory() {
    const isExpense = this.kindTarget.value === "expense"

    this.categoryWrapperTarget.classList.toggle("d-none", !isExpense)
    if (!isExpense) this.categorySelectTarget.value = ""
  }
}
