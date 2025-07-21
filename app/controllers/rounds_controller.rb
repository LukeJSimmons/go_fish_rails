class RoundsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :record_user_activity

  def create
    game = Game.find(params["game_id"])
    round_form = RoundForm.new(round_form_params)
    return redirect_to game, error: "Invalid request" unless round_form.valid?
    game.play_round!(params["round"]["target"], params["round"]["request"])
    redirect_to game
  end

  private

  def round_form_params
    params.require(:round).permit(:target, :request)
  end

  def record_user_activity
    current_user.active_now! if current_user
  end
end
