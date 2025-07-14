import consumer from "./consumer"

consumer.subscriptions.create({channel: "GameChannel", id: document.getElementById('game_id').dataset.id}, {
  connected() {
    console.log("Connected to Actioncable")
  },

  disconnected() {
    console.log("Disconnect from ActionCable!")
  },

  received(data) {
    window.location.reload()
  }
});
