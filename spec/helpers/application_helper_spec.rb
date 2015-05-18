require 'rails_helper'

describe ApplicationHelper do
  let(:user)               { create(:user) }
  let(:user_with_username) { create(:user_with_username)}
  
  context '#account_links' do
    it 'returns proper account links when a user is not logged in' do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      
      expected_output = link_to("Create Account", new_user_registration_path) + ' | ' +
        link_to("Log In", new_user_session_path)
      
      expect(helper.account_links).to eq(expected_output)
    end
    
    it 'returns proper account links when a user is logged in' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:current_user).and_return(user)
      
      expected_output = "Welcome " + link_to(user.email, edit_user_registration_path) + ' | ' +
        link_to("Log Out", destroy_user_session_path, method: :delete)
      
      expect(helper.account_links).to eq(expected_output)
    end
    
    it 'returns proper account links when a user logged in and has set username' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:current_user).and_return(user_with_username)
      
      expected_output = "Welcome " + link_to(user_with_username.username, edit_user_registration_path) + ' | ' +
        link_to("Log Out", destroy_user_session_path, method: :delete)
      
      expect(helper.account_links).to eq(expected_output)
    end
  end
end