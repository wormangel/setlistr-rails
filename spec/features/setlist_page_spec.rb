require "rails_helper"
require "features/shared_examples/common.rb"
require "support/features_steps"

feature "The setlist page" do
  include FeaturesSteps
  
  before do
    visit_homepage
    click_to_login_and_allow_fb_connection
    visit_band_create_page
    create_band_with_name_and_instrument("Guns n' Lillys", "Guitar")
    click_to_logout
    visit_setlist_for_band("Guns n' Lillys")
  end
  
  it_behaves_like 'a page for authenticated users'
  
  context 'when accessed by an authenticated user' do
    before do
      visit_homepage
      click_to_login_and_allow_fb_connection
      visit_setlist_for_band("Guns n' Lillys")
    end

    context 'and the setlist is empty' do
      scenario 'displays a message about no songs in the setlist' do
        should_see_message_about_empty_setlist
      end
    end
    
    context 'and the setlist has songs' do
      before do
        add_song_with_author_and_name("BC/DC", "Dynamite")
        add_song_with_author_and_name("Motorneck", "Ace of Spades")
      end
      
      scenario 'displays the songs in the setlist' do
        should_see_song_in_setlist_with_name("Dynamite")
        should_see_song_in_setlist_with_name("Ace of Spades")
      end
    end
    
    scenario 'displays a form to add a new song to the setlist' do
      should_see_new_song_fields
    end
    
    scenario 'requires author and title to be filled before adding song' do
      click_button "Add song"
      should_see_validation_message
    end
    
    context 'and the user fills the form and clicks Add Song' do
      context 'if the song is not already on the setlist' do
        scenario 'adds the song to the setlist' do
          should_see_setlist_with_song_count(0)
          add_song_with_author_and_name("BC/DC", "Dynamite")
          should_see_setlist_with_song_count(1)
          should_see_song_in_setlist_with_name("Dynamite")
        end
      end
      
      context 'if the song is already on the setlist' do
        before do
          add_song_with_author_and_name("BC/DC", "Dynamite")
        end
        
        scenario 'ignores the addition and redisplays the page' do
          should_see_setlist_with_song_count(1)
          add_song_with_author_and_name("BC/DC", "Dynamite")
          should_see_setlist_with_song_count(1)
        end
      end
    end
    
    
  end
end