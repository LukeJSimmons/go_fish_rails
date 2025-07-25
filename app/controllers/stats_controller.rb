class StatsController < ApplicationController
  def index
    @q = Stat.ransack(params[:q])
    @stats = @q.result.page params[:page]
  end
end
