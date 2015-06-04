require 'rails_helper'
feature 'Reset Password' do
  let!(:user) { create(:user, email: 'rich@example.com', password: 'Abcd1234') }

  before do
    ActionMailer::Base.deliveries = []
    visit new_user_password_path
  end

  context 'is successful' do
    scenario 'when an existing user email is entered' do
      fill_in 'user_email', with: user.email
      click_button 'Send me reset password instructions'

      expect(page).to have_content('You will receive an email with '\
          'instructions on how to reset your password in a few minutes')
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context 'is unsuccessful' do
    scenario 'when an email does not match any existing users' do
      fill_in 'user_email', with: 'test@test.com'
      click_button 'Send me reset password instructions'

      expect(page).to have_content('Email not found')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
end
