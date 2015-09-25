module AuthSteps
  def login_with_facebook
    page.find("#fb_login_btn").click
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
