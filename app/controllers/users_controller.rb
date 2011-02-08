class UsersController < ApplicationController
  def new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name # cross-site scripting auto filtered     
  end
  
end
