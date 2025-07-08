class GameUsersController < ApplicationController
  def create
    @game_user = GameUser.new(game_user_params)
    @game_user.game.users << @game_user.user
    redirect_to @game_user.game
  end

  private

  def game_user_params
    params.permit(:game_id, :user_id)
  end
end
