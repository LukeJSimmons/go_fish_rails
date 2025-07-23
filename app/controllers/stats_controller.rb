class StatsController < ApplicationController
  def index
    @q = Stat.ransack(params[:q])
    @stats = @q.result.order(total_wins: :desc).page params[:page]
  end
end
