require 'support/features_steps.rb'

shared_examples "a page for authenticated users" do
  include FeaturesSteps
  
  context "when accessed by an anonymous user" do
    scenario "redirects to login page" do
      should_see_login_page
    end
  end
  
  context "when acessed by an authenticated user" do
    before do
      click_to_login_and_allow_fb_connection
    end
  
    scenario "displays a logout button" do
      should_have_logout_button
    end
    
    scenario "logout the user when he clicks on Logout" do
      click_to_logout
      should_see_login_page
    end
  end

end