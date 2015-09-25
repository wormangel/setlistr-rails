require "rails_helper"
require "support/auth_steps"

feature "Acessing the homepage" do
  include AuthSteps

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
          prepare_facebook_login_success
        end
        
        scenario "redirects to dashboard" do
          login_with_facebook
          should_redirect_to_dashboard
        end
      end

      context "and the authentication fails" do
        before do
          prepare_facebook_login_failure
        end

        scenario "refreshes displaying the error" do
          login_with_facebook
          should_redisplay_login_with_error
        end
      end
    end
  end

  context "when the user is logged in" do
    before do
      prepare_facebook_login_success
      login_with_facebook
    end

    scenario "redirects to dashboard" do
      should_redirect_to_dashboard
    end
  end
end
