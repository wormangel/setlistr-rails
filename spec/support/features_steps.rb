module FeaturesSteps
  # Visit actions

  def visit_homepage
    visit("/")
  end
  
  def visit_dashboard
    visit('/user/dashboard')
  end
  
  def visit_band_create_page
    visit('/band/new')
  end
  
  def visit_band_page(name)
    id = Band.find_by(:name => name).id.to_s
    visit('/band/' + id)
  end
  
  # Homepage UI itens and actions
  
  def should_see_facebook_login_button
    expect(page).to have_link("fb_login_btn")
  end
  
  def should_see_login_screen_with_error
    expect(page).to have_link("fb_login_btn")
    expect(page).to have_selector(".alert-danger")
  end
  
  def click_to_login_and_allow_fb_connection
    prepare_facebook_login_success
    page.find("#fb_login_btn").click
  end
  
  def click_to_login_and_deny_fb_connection
    prepare_facebook_login_failure
    page.find("#fb_login_btn").click
  end
  
  def should_see_login_page
    expect(page).to have_link("fb_login_btn")
  end
  
  private
  def prepare_facebook_login_failure
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
  
  private
  def prepare_facebook_login_success
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '12345',
      :info => {'name' => 'John Doe'},
      :credentials => {'token' => 'abc123', 'expires_at' => 0}
    })
  end

  # Common Auth-only pages UI itens and actions
  
  def should_have_logout_button
    expect(page).to have_link("logout_btn")
  end
  
  def click_to_logout
    page.find("#logout_btn").click
  end
  
  # Dashboard UI itens and actions

  def should_see_dashboard
    expect(page).to have_selector("#dashboard")
  end
  
  def should_see_button_to_create_new_band
    expect(page).to have_link("create_band_btn")
  end
  
  def should_see_message_about_not_having_any_bands
    expect(page).to have_selector("#no_bands_msg")
  end
  
  def should_see_list_with_band_named(name)
    expect(page).to have_selector("#band_list")
    expect(find("#band_list")).to have_text(name)
  end
  
  def should_see_image_placeholder
    expect(page).to have_selector(".img_placeholder")
  end
  
  def click_band(name)
    click_on(name)
  end
  
  # Band create page UI and actions
  
  def create_band_with_name_and_instrument(name, instrument)
    fill_in "name", with: name
    select instrument, from: 'instrument'
    click_button "Create band"
  end
  
  def should_see_band_name_field
    expect(page).to have_field("name")
  end
  
  def should_see_musical_instrument_dropdown
    expect(page).to have_field("instrument")
  end
  
  def should_see_validation_message
    expect(page).to have_text("can't be blank")
  end
  
  def should_see_page_for_band(band_name)
    expect(page).to have_selector(".band_page") 
    expect(page).to have_text(band_name)
  end
  
  # Band page UI and actions
  
  def should_see_link_to_setlist
    expect(page).to have_selector("#nav_setlist")
  end
  
  def should_see_setlist
    expect(page).to have_selector("#setlist_page")
  end
end