require "rails_helper"
require "features/shared_examples/common.rb"
require "support/features_steps"

feature "Creating a band" do
  include FeaturesSteps
  
  it_behaves_like 'a page for authenticated users'
  
  before do
    visit('/band/new')
  end
  
  scenario "automatically includes the current user as a member" do
    # Visit new band page
    # Create new band choosing a random instrument
    # Verify association
  end
  
end