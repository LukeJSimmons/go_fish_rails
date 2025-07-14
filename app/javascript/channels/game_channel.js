import consumer from "./consumer"

consumer.subscriptions.create({channel: "GameChannel"}, {
  connected() {
    console.log("Connected to Actioncable")
  },

  disconnected() {
    console.log("Disconnect from ActionCable!")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    window.location.reload()
  }
});
