class StatsController < ApplicationController
  def index
    @users = User.order(:username).page params[:page]
  end
end
