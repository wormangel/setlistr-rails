require 'rails_helper'
require 'support/controller_steps'

RSpec.describe UserController, type: :controller do
  include ControllerSteps
  
  describe "GET #dashboard" do
    let(:band_A) { create(:band) }
    let(:band_B) { create(:band) }
    let(:band_C) { create(:band) }
    let(:user_with_no_bands) { create(:user_with_contracts) }
    let(:user_with_bands_A_and_B) { create(:user_with_contracts, bands: [band_A, band_B]) }
    let(:user_with_band_C) { create(:user_with_contracts, bands: [band_C]) }

    before do
      user_with_no_bands
      user_with_bands_A_and_B
      user_with_band_C
    end

    it "returns no bands if the user doesn't have any bands" do
      login(user_with_no_bands)
      get(:dashboard)
      expect(assigns(:contracts)).to eq([])
    end

    it "returns only the bands in which the logged in user participates" do
      login(user_with_bands_A_and_B)
      get(:dashboard)
      expect(assigns(:contracts)).to eq(user_with_bands_A_and_B.contracts)
    end
  end
end
