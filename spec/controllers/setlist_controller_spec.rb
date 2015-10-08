require 'rails_helper'
require "controllers/shared_examples/common.rb"
require 'support/controller_steps.rb'

RSpec.describe SetlistController, type: :controller do
  include ControllerSteps
  
  describe "GET #show" do
    it_should_behave_like "a band members only page", "show", "band_id"
  end
  
  #TODO Code here is too repetitive. Improve
  describe "POST #add_song" do
    let(:band_A) { create(:band) }
    let(:user) { create(:user_with_contracts, bands: [band_A]) }
    
    it_should_behave_like "a band members only page", "show", "band_id"
    
    before do
      login(user)
      @song_params = attributes_for(:song)
    end
    
    context 'when the song does not exists in the db' do      
      it 'creates a new song entry' do
        expect { post :add_song, :band_id => band_A.id, :song => @song_params }.to change(Song, :count).by(1)
      end
    end
    
    context 'when the song already exists in the db' do
      before do
        Song.create(@song_params)
      end

      it 'does not create a new song entry' do
        expect { post :add_song, :band_id => band_A.id, :song => @song_params }.to change(Song, :count).by(0)
      end    
    end
    
    context 'when the song is not on the setlist' do      
      it 'adds the song to the setlist' do
        expect { post :add_song, :band_id => band_A.id, :song => @song_params }.to change(SetlistSong, :count).by(1)
      end
    end
    
    context 'when the song is already on the setlist' do
      before do
        song = Song.create(@song_params)
        SetlistSong.create(:setlist => band_A.setlist, :song => song)
      end
      
      it 'doesn\'t change the setlist' do
        expect { post :add_song, :band_id => band_A.id, :song => @song_params }.to change(SetlistSong, :count).by(0)
      end      
    end
  end
end
