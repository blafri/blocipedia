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