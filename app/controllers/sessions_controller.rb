class SessionsController < ApplicationController
  
  # Show signin form
  def new
    @title = "Sign in"
    # logger.info "XXXX Showing signin form"
  end

  # Signin -> i.e. create new session 
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      # error
      logger.info "*** SessionsController: signin fail"
      flash.now[:error] = "Invalid email/password combination."    
      @title = "Sign in"
      render 'new'
    else
      # sign in user and redirect to user's show page
      sign_in user 
      redirect_to user
      logger.info "*** SessionsController: signin success"
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
