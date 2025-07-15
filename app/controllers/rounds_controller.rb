class RoundsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    game = Game.find(params["game_id"])
    round_form = RoundForm.new(round_form_params)
    return redirect_to game, error: "Invalid request" unless round_form.valid?
    game.play_round!(params["round"]["target"], params["round"]["request"])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update(
          dom_id(game, current_user.id),
          partial: "games/game", locals: { game: game, user: current_user }
        ) }
      format.html { redirect_to game }
    end
  end

  private

  def round_form_params
    params.require(:round).permit(:target, :request)
  end
end
