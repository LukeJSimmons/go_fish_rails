class ObservableGamesController < ApplicationController
  def index
    @q = Game.ransack(params[:q])
    @games = @q.result(distinct: true).order(:name).page params[:page]
    @games = @games.joins(:game_users).where(game_users: { user_id: params[:user_id] }) if params[:user_id]
  end
end
