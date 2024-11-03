import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "nextButton", "submitButton"]

  connect() {
    this.toggleNextButton()
  }

  toggleNextButton() {
    const checkedAnswers = this.formTarget.querySelectorAll('input[type="checkbox"]:checked')
    
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.disabled = checkedAnswers.length === 0
    }
    
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = checkedAnswers.length === 0
    }
  }
} 