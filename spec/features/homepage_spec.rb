require "rails_helper"
require "support/auth_steps"

feature "The homepage" do
  include AuthSteps

  context "when the user is not logged in" do

    scenario "shows the Login form" do
      visit_homepage
      should_see_facebook_login_button
    end
  end
end
