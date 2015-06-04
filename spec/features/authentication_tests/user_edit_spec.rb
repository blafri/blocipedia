require 'rails_helper'

feature 'Edit user account' do
  let(:user) { create(:user) }

  before do
    # Sign In and visit user account page
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log In'
    visit edit_user_registration_path
  end

  scenario 'update user name' do
    fill_in 'user_username', with: 'blafri'
    click_button 'Update'

    expect(User.find(user.id).username).to eq('blafri')
    expect(page).to have_content('Welcome blafri')
    expect(page).to have_content('Account settings updated successfully')
  end

  scenario 'send password reset email' do
    ActionMailer::Base.deliveries = []
    click_link 'Send Password Reset Email'

    expect(page).to have_content('You will receive an email with instructions'\
        ' on how to reset your password in a few minutes.')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
