import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hand"
export default class extends Controller {
  static targets = ['cards']

  sort_by_rank() {
    const sorted_cards = [...this.cardsTarget.children].sort(this.by_value)
    sorted_cards.forEach(node => this.cardsTarget.appendChild(node));
  }

  sort_by_suit() {
    const sorted_cards = [...this.cardsTarget.children].sort(this.by_suit)
    sorted_cards.forEach(node => this.cardsTarget.appendChild(node));
  }

  private

  by_value(a,b) {
    const a_value = a.dataset.value
    const b_value = b.dataset.value
    return parseInt(a_value) > parseInt(b_value) ? 1 : -1
  }

  by_suit(a,b) {
    const suits = ['H', 'D', 'S', 'C']
    const a_suit = suits.indexOf(a.dataset.suit)
    const b_suit = suits.indexOf(b.dataset.suit)
    return a_suit > b_suit ? 1 : -1
  }
}
