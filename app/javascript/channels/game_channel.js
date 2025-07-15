import consumer from "./consumer"

consumer.subscriptions.create({channel: "GameChannel", id: document.getElementById('game_id').dataset.id}, {
  connected() {
    console.log("Connected to Actioncable")
  },

  disconnected() {
    console.log("Disconnect from ActionCable!")
  },

  received(data) {
    this.appendResult(data)
  },

  appendResult(data) {
    const html = this.createResult(data)
    const element = document.querySelector(".feed__output")
    element.insertAdjacentHTML("afterbegin", html)
  },

  createResult(data) {
    return `
      <div class="feed__response-group">
        <div class="feed__bubble feed__bubble--player-action">${data["player_action"]}</div>
        <div class="feed__response">
          <i class="icon ph ph-arrow-elbow-down-right"></i>
          <div class="feed__bubble feed__bubble--player-response">${data["player_response"]}</div>
        </div>
        <div class="feed__response">
          <i class="icon ph ph-arrow-elbow-down-right"></i>
          <div class="feed__bubble feed__bubble--game-response">${data["game_response"]}</div>
        </div>
      </div>
    `
  }
});
