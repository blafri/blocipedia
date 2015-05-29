require 'rails_helper'

feature "Upgrade account to premium" do
  let(:user) { create(:user) }
  scenario "is successful", js: true do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Log In"
    click_on user.email
    click_on "Upgrade Account"
    click_on "create-charge"
    click_on "Pay with my PayPal account"
    fill_in "login_email", with: ENV["PAYPAL_USER"]
    fill_in "login_password", with: ENV["PAYPAL_PASSWORD"]
    click_button "submitLogin"
    expect(page).to have_content("Review your information", wait: 10)
    click_on "continue"
    click_on "Place Order"
    
    expect(page).to have_content("Your account was successfully upgraded", wait: 10)
    expect(page).to have_content("Downgrade Account")
    expect(User.first.role).to eq('premium')
    expect(User.first.paypal_sale_id).not_to eq(nil)
  end
end