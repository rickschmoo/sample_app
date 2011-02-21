module SessionsHelper

  ###############
  # SIGN USER IN
  ###############
	def sign_in(user)
	  # The assignment value on the right-hand side is an array
	  # consisting of a unique identifier (i.e., the user’s id) and
	  # a secure value used to create a digital signature to prevent
	  # the kind of attacks described in Section 7.2.	  
		cookies.permanent.signed[:remember_token] = [user.id, user.salt] 
		current_user = user # create current_user, accessible in both controllers and views
	end 

  ###############
  # SIGN USER OUT
  ###############
	def sign_out
	  cookies.delete(:remember_token)
	  current_user = nil
	end
	
	# Check if this is the current logged_in user
	def current_user?(user)
    user == current_user
	end
	
	#######################
	# DENY ACCESS TO A PAGE
	#######################
	def deny_access
	  store_location
	  redirect_to signin_path, :notice => "Please sign in to access this page"
	  # :notice argument implicitly calls flash[:notice]
	end

	#######################
	# REDIRECT BACK TO
	#######################
	def redirect_back_or(default)
	  redirect_to(session[:return_to] || default)
	  clear_return_to
	end
		
	##################
	# SUPPORT METHODS
	##################
	
	# method 'current_user=' expressly designed to handle assignment
	#to current_user
	def current_user=(user) # 
    @current_user = user
	end
	
	def current_user
	  # OR EQUALS OPERATOR ||=
	  # set the @current_user instance variable to the user corresponding
	  # to the remember token, but only if @current_user is undefined
	  # i.e. only calls user_from_remember_token on first call
	  @current_user ||= user_from_remember_token
	end
	
	# a user is signed_in if the current_user is not nil!
	def signed_in?
	  !current_user.nil?
	end
	
	
	
  #######################	
	# PRIVATE METHODS
	#######################
	private
	  def user_from_remember_token
	    #  the * operator, which allows us to use a two-element array
	    # as an argument to a method expecting two variables
	    User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      # returns an array of two elements—the user id and the salt
      cookies.signed[:remember_token] || [nil, nil]
    end


    # support functions for redirect_back_to
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
