require 'rails_helper'
require "controllers/shared_examples/common.rb"
require 'support/controller_steps'

RSpec.describe BandController, type: :controller do
  include ControllerSteps
  
  describe "POST #create" do
    let(:user_with_no_bands) { create(:user) }
    
    before do
      login(user_with_no_bands)
      
      # TODO There should be a way to automatize this
      @band_params = attributes_for(:band)
      @band_params[:contract_attributes] = [attributes_for(:contract)]
    end
    
    it 'creates band' do
      expect { post :create, :band => @band_params }.to change(Band, :count).by(1)
    end
    
    it 'associates the logged user with the band' do
      post :create, :band => @band_params
      expect(Contract.exists?(band: Band.last, user: user_with_no_bands)).to be_truthy
    end
  end
  
  describe "GET #show" do
    it_should_behave_like "a band members only page", "show", "id"
  end  

end
