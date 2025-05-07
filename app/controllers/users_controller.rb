class UsersController < ApplicationController

  def show 
    user = User.find(params[:id])
    @nickname = user.nickname
    @tweets = user.tweets.order(created_at: :desc)
  end
end
