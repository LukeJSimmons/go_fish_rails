class StatsController < ApplicationController
  def index
    @users = User.all
  end
end
