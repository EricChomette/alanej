
import { Controller } from 'stimulus';
export default class extends Controller {

  static targets = ["icon", "input"]

  updateDisplay(rating) {
    this.iconTargets.forEach(icon => {
      const full = icon.dataset.rating <= rating
      icon.classList.toggle('fas', full)
      icon.classList.toggle('far', !full)
    });
  }

  removeRating() {
    this.updateDisplay(0)
    this.currentRating = 0
    this.inputTarget.value = 0
  }

  setRating(rating) {
    this.currentRating = rating
    this.updateDisplay(rating)
    this.inputTarget.value = rating
  }

  mouseOver(e) {
    this.updateDisplay(e.currentTarget.dataset.rating)
  }

  mouseOut(e) {
    this.updateDisplay(this.currentRating)
  }

  click(e) {
    if (e.currentTarget.dataset.rating == this.currentRating)
      this.removeRating()
    else
      this.setRating(e.currentTarget.dataset.rating)
  }

  connect() {
    this.currentRating = 0
  }
}
