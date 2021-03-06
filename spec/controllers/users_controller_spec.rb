require 'spec_helper'

describe UsersController do
  
  render_views


  #####################
  # SHOW user homepage
  ####################
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
  
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user # assigns returns @auser handle
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
        
  end

  ############################
  # NEW test - show signup form
  ############################
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
  
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    it "should have a confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
    
  end

  ######################################
  # POST test - signup form submission
  ######################################
  describe "POST 'create'" do
    
    #################
    # FAILED SIGNUP
    ################
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end
  
      it "should not create a user" do
        # lambda allows check of User.count
        lambda do
          post :create, :user => @attr
        # change refers to the Active Record count method -> counts #users in the database
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
 
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end # describe "failure" do
  
    ####################
    # SUCCESSFUL SIGNUP
    ###################
    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
          post :create, :user => @attr
          flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      
    end # describe "success" do
    
  end # end describe "POST 'create'" do

  ############################
  # EDIT action - check edit form
  ############################
  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
  
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end
    
    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url, :content => "change")
    end
    
  end # describe "GET 'edit'" do
  
  ############################
  # UPDATE action - submit edit form
  ############################
  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    #################
    # FAILED UPDATE
    ################ 
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
 
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
    end # describe "failure" do
  
    ####################
    # SUCCESSFUL UPDATE
    ###################
    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user22@example.com", 
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should flash a message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
      end
      
    end # describe "success" do 
    
  end  # describe "PUT 'update'" do
  
  ######################################
  # USER AUTHENTICATION FOR EDIT/UPDATE
  ######################################
  describe "authentication of edit/update pages" do 
    
    before(:each) do
      @user = Factory(:user)
    end
    
    ######################
    # NON SIGNED-IN USERS
    ######################
    describe "for non-signed-in users" do
      
      it "should deny access to edit" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to update" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(signin_path)
      end  
      
    end
    
    ######################
    # SIGNED-IN USERS EDITING
    # ANOTHER USER'S PAGE
    ######################
    describe "for non-signed-in users on wrong page" do
      
      before(:each) do
        # sign in as another user
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end      
      
      it "should require matching users for an EDIT" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      
      it "should require matching users for an UPDATE" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
      
    end
  end # describe "authentication of edit/update pages" do

  ######################################
  # USERS INDEX PAGE
  ######################################
  describe "GET index" do
    
    describe "for non-signed in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end 
    
    describe "for signed in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third = Factory(:user, :email => "another@example.net")
        
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2", :content => "2")
        response.should have_selector("a", :href => "/users?page=2", :content => "Next")        
      end
      
    end 
    
  end  # describe "GET index" do

  ######################################
  # USER DELETE destroy user (only for admins)
  ######################################
  describe "DELETE destroy" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end 
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
     
    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
        
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the user's page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
      
    end

  end  # describe "DELETE destroy" do
  
end
