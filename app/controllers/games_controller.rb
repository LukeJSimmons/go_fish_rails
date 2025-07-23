class GamesController < ApplicationController
  def index
    @games = Game.order(:name).page params[:page]
    @games = @games.where(end_time: nil)
    @games = @games.joins(:game_users).where(game_users: { user_id: params[:user_id] }) if params[:user_id]
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.users << current_user

    if @game.save
      @game.start_if_possible!
      return redirect_to games_path
    end
    render new_game_path, status: :unprocessable_entity
  end

  def show
    @game = Game.find(params[:id])
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
    params.require(:game).permit(:name, :players_count, :bots_count, :bot_difficulty)
  end
end
