require "rails_helper"
require "features/shared_examples/common.rb"
require "support/features_steps"

feature "The band creation page" do
  include FeaturesSteps
  
  before do
    visit_band_create_page
  end
  
  it_behaves_like 'a page for authenticated users'
  
  context 'when accessed by an authenticated user' do
    before do
      visit_homepage
      click_to_login_and_allow_fb_connection
      visit_band_create_page
    end
  
    scenario "has a field for the band name" do
      should_see_band_name_field
    end
  
    scenario "has a select field for instrument the user plays" do
      should_see_musical_instrument_dropdown
    end
    
    scenario 'requires the band name to be filled' do
      click_button "Create band"
      should_see_validation_message
    end
    
    scenario "shows the band page after successfully creating the band" do
      create_band_with_name_and_instrument("Guns n' Lillys", "Guitar")
      should_see_page_for_band("Guns n' Lillys")
    end
  end
  
  
end