require "rails_helper"
require "features/shared_examples/common.rb"
require "support/dashboard_steps"
require "support/auth_steps"

feature "Acessing the dashboard" do
  include DashboardSteps
  include AuthSteps
  
  it_behaves_like "a page for authenticated users"

  before do
    visit_dashboard
  end
end