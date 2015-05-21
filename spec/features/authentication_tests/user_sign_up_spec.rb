require 'rails_helper'

feature "Sign up" do
  let(:email) { 'rich.froning@example.com' }
  let(:password) { 'Abcd1234' }
  let(:invalid_email) { 'rich.froning@example' }
  let(:invalid_password) { 'a' }
  let(:user) { create(:user, email: 'rich.froning@example.com') }
  
  before do
    ActionMailer::Base.deliveries = []
    visit new_user_registration_path
  end
  
  scenario "form is displayed when you visit users/sign_up" do
    visit new_user_registration_path
    expect(page).to have_content('Sign Up')
  end
  
  context "with valid information" do
    scenario "is successfull and email is sent" do
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      click_button "Sign Up"
      
      expect(current_path).to eq(root_path)
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account')
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries[0].to.include?(email)).to eq(true)
    end
  end
  
  context "with invalid" do
    scenario "email address fails" do
      fill_in 'user_email', with: invalid_email
      fill_in 'user_password', with: password
      click_button "Sign Up"
      
      expect(page).to have_content('Email is invalid')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      expect(User.count).to eq(0)
    end
    
    scenario "password (password too short) fails" do
      fill_in 'user_email', with: email
      fill_in 'user_password', with: invalid_password
      click_button "Sign Up"
      
      expect(page).to have_content('Password is too short')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      expect(User.count).to eq(0)
    end
  end
  
  context "with missing" do
    scenario "email address fails" do
      fill_in 'user_password', with: password
      click_button "Sign Up"
      
      expect(page).to have_content('Email can\'t be blank')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      expect(User.count).to eq(0)
    end
    
    scenario "password fails" do
      fill_in 'user_email', with: email
      click_button "Sign Up"
      
      expect(page).to have_content('Password can\'t be blank')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      expect(User.count).to eq(0)
    end
  end
  
  scenario "with an email that is already a user fails" do
    #create the user in the database
    user
    
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button "Sign Up"
    
    expect(page).to have_content('Email has already been taken')
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    expect(User.count).to eq(1)
  end
end