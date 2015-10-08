require 'rails_helper'

RSpec.describe Band, type: :model do
  describe Band do
    it 'initializes an empty Setlist upon creation' do
      expect { Band.create(attributes_for(:band)) }.to change(Setlist, :count).by(1)
    end
  end
end
