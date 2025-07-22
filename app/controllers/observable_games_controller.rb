class ObservableGamesController < ApplicationController
  def index
    @games = Game.with_game_ids(params["user_game_ids"] || current_user.game_ids).order(:name).page params[:page]
  end
end
