require 'rails_helper'

describe ApplicationHelper do
  let(:user)           { create(:user) }
  let(:user_with_name) { create(:user_with_username) }

  context '#account_links' do
    it 'returns proper account links when a user is not logged in' do
      allow(helper).to receive(:user_signed_in?).and_return(false)

      output = link_to('Create Account', new_user_registration_path) + ' | ' +
               link_to('Log In', new_user_session_path)

      expect(helper.account_links).to eq(output)
    end

    it 'returns proper account links when a user is logged in' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:current_user).and_return(user)

      output = 'Welcome ' +
               link_to(user.email, edit_user_registration_path) + ' | ' +
               link_to('Log Out', destroy_user_session_path, method: :delete)

      expect(helper.account_links).to eq(output)
    end

    it 'returns proper account links when a user logged in and has username' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:current_user).and_return(user_with_name)

      output = 'Welcome ' +
               link_to(user_with_name.username, edit_user_registration_path) +
               ' | ' +
               link_to('Log Out', destroy_user_session_path, method: :delete)

      expect(helper.account_links).to eq(output)
    end
  end

  context '#is_link_active' do
    it 'returns active if link is current link' do
      allow(helper).to receive(:current_page?).and_return(true)
      expect(helper.is_link_active('/test/link')).to eq('active')
    end

    it 'returns and empty string if current link is not active' do
      allow(helper).to receive(:current_page?).and_return(false)
      expect(helper.is_link_active('/test/link')).to eq('')
    end
  end

  context '#markdown_to_html' do
    it 'returns formated html from markdown text' do
      markdown = '# This is a *title*'
      html = '<h1 id="this-is-a-title">This is a <em>title</em></h1>'
      expect(helper.markdown_to_html(markdown).chomp).to eq(html)
    end

    it 'returns formatted html but strips all html tags entered by the user' do
      markdown = '<script>This should be escaped</script>'
      html = '<p>&lt;script&gt;This should be escaped&lt;/script&gt;</p>'
      expect(helper.markdown_to_html(markdown).chomp).to eq(html)
    end
  end
end
