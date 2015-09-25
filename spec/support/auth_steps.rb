module AuthSteps
  def visit_homepage
    visit("/")
  end

  def should_see_facebook_login_button
    expect(page).to have_link("fb_login_btn")
  end

  def login_with_facebook
    page.find("#fb_login_btn").click
  end

  def should_redirect_to_dashboard
    expect(page).to have_selector("#dashboard")
  end

  def should_redisplay_login_with_error
    expect(page).to have_link("fb_login_btn")
    expect(page).to have_selector(".alert-danger")
  end
  
  def prepare_facebook_login_failure
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
  
  def prepare_facebook_login_success
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '12345',
      :info => {'name' => 'John Doe'},
      :credentials => {'token' => 'abc123', 'expires_at' => 0}
    })
  end
end
