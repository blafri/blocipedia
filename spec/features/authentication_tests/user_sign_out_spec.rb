require 'rails_helper'

feature 'Sign out' do
  let!(:user) { create(:user, email: 'rich@example.com', password: 'Abcd1234') }

  scenario 'is successfull' do
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log In'
    click_on 'Log Out'

    expect(page).to have_content('Signed out successfully')
    expect(page).to have_content('Create Account')
  end
end
