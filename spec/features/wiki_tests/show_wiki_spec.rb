require 'rails_helper'
require 'support/sign_in_user'

feature 'View' do
  let(:user1)        { create(:premium_user) }
  let(:user2)        { create(:user) }
  let(:wiki)         { create(:wiki, user: user1) }
  let(:private_wiki) { create(:private_wiki, user: user1) }

  context 'public wiki' do
    scenario 'when not logged in is successful' do
      visit wiki_path(wiki)
      expect(page).to have_content(wiki.title)
    end

    scenario 'when logged in is successfull' do
      sign_in_user(user1)
      visit wiki_path(wiki)
      expect(page).to have_content(wiki.title)
    end
  end

  context 'private wiki' do
    scenario 'when not logged in is not successfull' do
      visit wiki_path(private_wiki)
      expect(page).to have_content('You must be logged in to view this '\
          'private wiki')
    end

    scenario 'after login you get redirected to the wiki you want to view' do
      visit wiki_path(private_wiki)
      expect(page).to have_content('You must be logged in to view this private'\
          ' wiki')
      fill_in 'user_email', with: user2.email
      fill_in 'user_password', with: user2.password
      click_button 'Log In'

      expect(page).to have_content(private_wiki.title)
    end

    scenario 'when logged in is successfull' do
      sign_in_user(user2)
      visit wiki_path(private_wiki)
      expect(page).to have_content(private_wiki.title)
    end
  end
end
