class GamesController < ApplicationController
  def index
    @your_games = current_user.games
    @all_games = Game.where.not(id: current_user.game_ids)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.users << current_user

    if @game.save
      redirect_to games_path
    else
      render new_game_path, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
    @game.start! if @game.users.count == @game.players_count
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])

    if @game.update(game_params)
      redirect_to games_path
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy!

    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :players_count)
  end
end
