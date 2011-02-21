class SessionsController < ApplicationController
  
  #########################
  # NEW -> Show signin form
  #########################
  def new
    @title = "Sign in"
    # logger.info "XXXX Showing signin form"
  end

  #############################################
  # CREATE -> Signin -> i.e. create new session 
  ############################################# 
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      # error
      #logger.info "*** SessionsController: signin fail"
      flash.now[:error] = "Invalid email/password combination."    
      @title = "Sign in"
      render 'new'
    else
      # sign in user and redirect to user's show page
      sign_in user 
      redirect_back_or user
      #logger.info "*** SessionsController: signin success"
    end
  end
  
  #########################
  # DESTROY -> end session
  #########################
  def destroy
    sign_out
    redirect_to root_path
  end

end
