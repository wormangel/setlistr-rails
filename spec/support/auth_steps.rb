module AuthSteps
  def visit_homepage
    visit("/")
  end

  def should_see_facebook_login_button
    expect(page).to have_link("fb_login_btn")
  end
end
