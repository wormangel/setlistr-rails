require 'rails_helper'
require "controllers/shared_examples/common.rb"
require 'support/controller_steps'

RSpec.describe SetlistController, type: :controller do
  include ControllerSteps
  
  describe "GET #show" do
    it_should_behave_like "a band members only page", "show", "band_id"
  end  
end
