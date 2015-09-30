require 'support/controller_steps.rb'

shared_examples "a band members only page" do |action, band_id_param|
  include ControllerSteps
  
  let(:band_A) { create(:band) }
  let(:user_with_no_bands) { create(:user) }
  let(:user_with_band_A) { create(:user_with_contracts, bands: [band_A]) }

  context 'when user is a member of the band' do
    before do
      login(user_with_band_A)
    end
  
    it 'allows access' do
      get action, band_id_param => band_A.id
      expect(response).to have_http_status(:ok)
    end
  end
  
  context 'when user is not a member of the band' do
    before do
      login(user_with_no_bands)
    end
    it 'redirects user to dashboard' do
      expect(get action, band_id_param => band_A.id).to redirect_to :action => :dashboard, :controller => :user
    end
  end
end