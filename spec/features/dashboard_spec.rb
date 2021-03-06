require "rails_helper"
require "features/shared_examples/common.rb"
require "support/features_steps"

feature "The dashboard" do
  include FeaturesSteps
  
  before do
    visit_dashboard
  end
  
  it_behaves_like "a page for authenticated users"
  
  context "when the user is authenticated" do  
    before do
      visit_homepage
      click_to_login_and_allow_fb_connection
      visit_dashboard
    end
  
    scenario 'displays a button to create a new band' do
      should_see_button_to_create_new_band
    end
  
    context 'and doesn\'t have any bands' do
      scenario 'displays an empty list of bands' do
        should_see_message_about_not_having_any_bands
      end
    end
  
    context 'and has bands' do
      before do
        visit_band_create_page
        create_band_with_name_and_instrument("Iron Maid", "Guitar")
        visit_dashboard
      end
    
      scenario 'displays a list of the bands where the user is a member' do
        should_see_list_with_band_named("Iron Maid")
      end
      
      scenario 'displays a placeholder for bands with no logos' do
        should_see_image_placeholder
      end
      
      scenario 'makes the band buttons clickable leading to the band page' do
        click_band("Iron Maid")
        should_see_page_for_band("Iron Maid")
      end
    end
  end 
  
end