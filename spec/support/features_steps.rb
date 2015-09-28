module FeaturesSteps
  # Visit actions

  def visit_homepage
    visit("/")
  end
  
  def visit_dashboard
    visit('/user/dashboard')
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
  
  
end