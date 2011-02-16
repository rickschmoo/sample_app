require 'spec_helper'

describe "Users" do
  
  ##############
  # SIGNUP TEST
  ##############
  describe "signup" do
    
    describe "success" do
      
      it "should  make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",             :with  => "Schmoo Baggins"
          fill_in "Email",            :with  => "schmoo@baggins.org"
          fill_in "Password",         :with  => "hello123"
          fill_in "Confirmation",     :with  => "hello123"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end # describe "success" do
    
    describe "failure" do
      
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",             :with  => ""
          fill_in "Email",            :with  => ""
          fill_in "Password",         :with  => ""
          fill_in "Confirmation",     :with  => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count) 
      end
    end # describe "failure" do
    
  end # describe "signup" do
  
  ##############
  # SIGNIN TEST
  ##############
  describe "sign in/out" do

    describe "failure" do
      
      it "should not sign a user in" do
        #integration_sign_in(nil) # failed to replace the following lines with call to integration_sign_in
        visit signin_path
        fill_in :email,	:with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in(user) 
          #visit signin_path
          #fill_in :email,	:with => user.email
          #fill_in :password, :with => user.password
          #click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
    
  end # describe "sign in/out" do

end # describe "Users" do

#  describe "GET /users" do
#    it "works! (now write some real specs)" do
#      get users_path
#    end
#  end
# end
