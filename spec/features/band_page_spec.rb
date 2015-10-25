require "rails_helper"
require "features/shared_examples/common.rb"
require "support/features_steps"

feature "The band page" do
  include FeaturesSteps
  
  before do
    visit_homepage
    click_to_login_and_allow_fb_connection
    visit_band_create_page
    create_band_with_name_and_instrument("Guns n' Lillys", "Guitar")
    click_to_logout
    visit_setlist_for_band("Guns n' Lillys")
  end
  
  it_behaves_like 'a page for authenticated users'
  
  context 'when accessed by an authenticated user' do
    before do
      visit_homepage
      click_to_login_and_allow_fb_connection
      visit_band_page("Guns n' Lillys")
    end

    scenario 'displays a link to the setlist page' do
      should_see_link_to_setlist
      click_on "Setlist"
      should_see_setlist
    end
    
    scenario 'displays a link to the concerts page' do
      should_see_link_to_concerts
      click_on "Concerts"
      should_see_concert_list
    end
    
    pending 'displays number of songs in the setlist'
  end
end