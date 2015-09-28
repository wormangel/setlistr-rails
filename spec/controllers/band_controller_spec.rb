require 'rails_helper'

RSpec.describe BandController, type: :controller do

  describe "GET #new" do
    context "user not authenticated" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end
    
    context "user authenticated" do
      it "returns http redirect" do
      end
    end
  end

end
