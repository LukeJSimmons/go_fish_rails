class RoundsController < ApplicationController
  def create
    @game = Game.find(params["game_id"])
    @round_form = RoundForm.new(round_form_params)
    @game.play_round!(params["target"], params["request"]) if @round_form.valid?
    redirect_to @game
  end

  private

  def round_form_params
    params.require(:round).permit(:target, :request)
  end
end
