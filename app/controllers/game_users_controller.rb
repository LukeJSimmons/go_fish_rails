class GameUsersController < ApplicationController
  def create
    return redirect_to games_path if Game.find(params["game_id"]).users.count == Game.find(params["game_id"]).players_count
    @game_user = GameUser.new(game_user_params)
    @game_user.game.users << @game_user.user
    @game_user.game.start_if_possible!
    redirect_to @game_user.game
  end

  private

  def game_user_params
    params.permit(:game_id, :user_id)
  end
end
