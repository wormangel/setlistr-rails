module CommonSteps  
  def should_see_login_page
    expect(page).to have_link("fb_login_btn")
  end
  
  def should_have_logout_button
    expect(page).to have_link("logout_btn")
  end
  
  def click_to_logout
    page.find("#logout_btn").click
  end
end