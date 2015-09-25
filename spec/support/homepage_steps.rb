module HomepageSteps
  def visit_homepage
    visit("/")
  end
  
  def should_see_facebook_login_button
    expect(page).to have_link("fb_login_btn")
  end

  def should_see_dashboard
    expect(page).to have_selector("#dashboard")
  end

  def should_see_login_screen_with_error
    expect(page).to have_link("fb_login_btn")
    expect(page).to have_selector(".alert-danger")
  end
end