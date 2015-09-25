module DashboardSteps
  def visit_dashboard
    visit('/user/dashboard')
  end
  
  def should_display_button_to_create_new_band
    expect(page).to have_link("create_band_btn")
  end
end