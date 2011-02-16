class UsersController < ApplicationController
  
  ###################
  # show signup form
  ###################
  def new
    @user = User.new
    @title = "Sign up" 
  end

  ##################
  # process signup
  ##################
  def create
    @user = User.new(params[:user]) 
    if @user.save
      sign_in @user
      # successful save
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
      logger.info "*** UsersController: new account created (" + @user.name + ")"
    else
      # submission fail!!
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
      logger.info "*** UsersController: new account fail (" + @user.name + ")"
    end
  end

  #####################
  # show user homepage
  #####################
  def show
    @user = User.find(params[:id])
    @title = @user.name # cross-site scripting auto filtered     
  end
  
end
