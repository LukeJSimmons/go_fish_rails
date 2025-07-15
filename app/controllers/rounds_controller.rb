class RoundsController < ApplicationController
  def create
    game = Game.find(params["game_id"])
    round_form = RoundForm.new(round_form_params)
    return redirect_to game, error: "Invalid request" unless round_form.valid?
    target_player = game.go_fish.players.find { |player| player.name == params["round"]["target"] }
    result = game.play_round!(target_player, params["round"]["request"])
    ActionCable.server.broadcast("game_#{game.id}", {
      player_action: result.player_action(:opponent),
      player_response: result.player_response(:opponent),
      game_response: result.game_response(:opponent)
    })
    redirect_to game
  end

  private

  def round_form_params
    params.require(:round).permit(:target, :request)
  end
end
