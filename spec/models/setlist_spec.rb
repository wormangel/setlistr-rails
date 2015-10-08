require 'rails_helper'

RSpec.describe Setlist, type: :model do
  describe Setlist do
    it 'provides a count of the number of songs in it' do
      setlist = create(:setlist)
      song_A = create(:song)
      setlist.songs << song_A
      
      expect(setlist.count).to eq(1)
    end
  end
end
