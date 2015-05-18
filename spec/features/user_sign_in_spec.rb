require 'rails_helper'

feature "Sign in" do
  let!(:user) { create(:user, email: 'rich.froning@example.com', password: 'Abcd1234') }
  
  before do
    visit new_user_session_path
  end
  
  context "is successfull" do
    scenario "with correct username and pasword" do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log In'
      
      expect(page).to have_content('Signed in successfully')
      expect(page).to have_content(user.email)
    end
  end
  
  context "is unsuccessful" do
    scenario "with wrong username and password" do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'njnjkdksnk'
      click_button 'Log In'
      
      expect(page).to have_content('Invalid email or password')
      expect(page).to have_content('Create Account')
    end
  end
end

feature "Sign out" do
  let!(:user) { create(:user, email: 'rich.froning@example.com', password: 'Abcd1234') }
  
  scenario "is successfull" do
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log In'
    click_on 'Log Out'
    
    expect(page).to have_content("Signed out successfully")
    expect(page).to have_content("Create Account")
  end
end

feature "Reset Password" do
  let!(:user) { create(:user, email: 'rich.froning@example.com', password: 'Abcd1234') }
  
  before do
    ActionMailer::Base.deliveries = []
    visit new_user_password_path
  end
  
  context "is successful" do
    scenario "when an existing user email is entered" do
      fill_in 'user_email', with: user.email
      click_button 'Send me reset password instructions'
      
      expect(page).to have_content('You will receive an email with instructions on how to reset your password in a few minutes')
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
  
  context "is unsuccessful" do
    scenario "when an email is entered that does not match any existing users" do
      fill_in 'user_email', with: 'test@test.com'
      click_button 'Send me reset password instructions'
      
      expect(page).to have_content('Email not found')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
end