require "rails_helper"
require "support/auth_steps"
require "support/homepage_steps"

feature "Acessing the homepage" do
  include AuthSteps
  include HomepageSteps

  before do
    visit_homepage
  end

  context "when the user is not logged in" do

    scenario "it shows the Facebook Login button" do
      should_see_facebook_login_button
    end

    context "and clicks \"Login With Facebook\"" do
      context "and authenticates successfully" do
        before do
          click_to_login_and_allow_fb_connection
        end
        
        scenario "redirects to dashboard" do
          should_see_dashboard
        end
      end

      context "and the authentication fails" do
        before do
          click_to_login_and_deny_fb_connection
        end

        scenario "refreshes displaying the error" do
          should_see_login_screen_with_error
        end
      end
    end
  end

  context "when the user is logged in" do
    before do
      click_to_login_and_allow_fb_connection
    end

    scenario "redirects to dashboard" do
      should_see_dashboard
    end
  end
end
