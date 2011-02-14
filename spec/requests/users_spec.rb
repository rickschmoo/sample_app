require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    
    describe "success" do
      
      it "should  make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",             with  => "Schmoo Baggins"
          fill_in "Email",             with  => "schmoo@baggins.org"
          fill_in "Password",             with  => "hello123"
          fill_in "Confirmation",             with  => "hello123"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
    
    describe "failure" do
      
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",             with  => ""
          fill_in "Email",             with  => ""
          fill_in "Password",             with  => ""
          fill_in "Confirmation",             with  => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count) 
      end
    end
    
  end

end

#  describe "GET /users" do
#    it "works! (now write some real specs)" do
#      get users_path
#    end
#  end
# end
