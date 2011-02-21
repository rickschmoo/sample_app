class UsersController < ApplicationController
  
  #####################################
  # authentication for protected pages
  #####################################
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  
  
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
  
  #####################
  # show edit user form
  #####################
  def edit
    # @user = User.find(params[:id])
    @title = "Edit user"   
  end

  ##################
  # process update
  ##################
  def update
    @user = User.find(params[:id]) 
    if @user.update_attributes(params[:user])
      # successful save
      flash[:success] = "Profile updated"
      redirect_to @user
      # logger.info "*** UsersController: account updated (" + @user.name + ")"
    else
      # submission fail!!
      @title = "Edit user"
      render 'edit'
      # logger.info "*** UsersController: new account fail (" + @user.name + ")"
    end
  end

  #####################
  # show index
  #####################
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  #####################
  # destroy user
  #####################
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User removed"
    redirect_to users_path
  end
  
###########################
  #########################
  # private support methods
  #########################
  private
  
    def authenticate
      deny_access unless signed_in?
    end  

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  

    def admin_user
      redirect_to(root_path) unless current_user.admin? 
    end  
    
end
