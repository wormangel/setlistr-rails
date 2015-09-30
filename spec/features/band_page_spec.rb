require "rails_helper"
require "features/shared_examples/common.rb"
require "support/features_steps"

feature "The band page" do
  include FeaturesSteps
  
  before do
    visit_band_create_page
  end
  
  it_behaves_like 'a page for authenticated users'
end