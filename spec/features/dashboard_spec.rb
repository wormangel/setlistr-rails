require "rails_helper"
require "features/shared_examples/common.rb"
require "support/dashboard_steps"
require "support/auth_steps"

feature "The dashboard" do
  include DashboardSteps
  include AuthSteps
  
  before do
    visit_dashboard
  end
  
  it_behaves_like "a page for authenticated users"
  
  context "when the user is authenticated" do  
    before do
      visit("/")
      click_to_login_and_allow_fb_connection
      visit_dashboard
    end
  
    scenario 'displays a button to create a new band' do
      should_see_button_to_create_new_band
    end
  
    context 'when the user doesn\'t have any bands' do
      pending 'display an empty list of bands'
    end
  
    context 'when the user has bands' do
      pending 'display a list of the bands where the user is a member'    
    end
  end
  
end