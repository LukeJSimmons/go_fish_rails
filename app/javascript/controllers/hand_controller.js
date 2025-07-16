import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hand"
export default class extends Controller {
  static targets = ['cards']
  sort() {
    const sorted_cards = [...this.cardsTarget.children].sort(this.sort_by_value)
    sorted_cards.forEach(node => this.cardsTarget.appendChild(node));
  }

  private

  sort_by_value(a,b) {
    const a_value = a.classList[a.classList.length-1]
    const b_value = b.classList[b.classList.length-1]
    return parseInt(a_value) > parseInt(b_value) ? 1 : -1
  }
}
