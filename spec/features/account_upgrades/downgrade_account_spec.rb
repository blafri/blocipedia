require 'rails_helper'

feature "Downgrade account to standard" do
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
    expect(page).to have_content("Review your information", wait: 20)
    click_on "continue"
    click_on "Place Order"
    expect(page).to have_content("Your account was successfully upgraded", wait: 20)
    click_on "Downgrade Account"
    
    expect(page).to have_content("Your account has been successfully downgraded and your money refunded.", wait: 20)
    expect(User.first.role).to eq('standard')
    expect(User.first.paypal_sale_id).to eq(nil)
  end
end