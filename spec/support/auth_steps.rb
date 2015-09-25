module AuthSteps
  def click_to_login_and_allow_fb_connection
    prepare_facebook_login_success
    page.find("#fb_login_btn").click
  end
  
  def click_to_login_and_deny_fb_connection
    prepare_facebook_login_failure
    page.find("#fb_login_btn").click
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
end
