require 'rails_helper'
require 'support/sign_in_user'

feature 'View' do
  let(:user1) { create(:premium_user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:admin_user) }
  let(:wiki) { create(:wiki, user: user1) }
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
      expect{visit wiki_path(private_wiki)}.to raise_error(Pundit::NotAuthorizedError)
    end

    scenario 'when logged in and a colaborator is successfull' do
      create(:colaborator, wiki: private_wiki, user: user2)
      sign_in_user(user2)
      visit wiki_path(private_wiki)
      expect(page).to have_content(private_wiki.title)
    end

    scenario 'when logged in and not a colaborator fails' do
      sign_in_user(user2)
      expect{visit wiki_path(private_wiki)}.to raise_error(Pundit::NotAuthorizedError)
    end

    scenario 'when logged in as an admin can view private wiki' do
      sign_in_user user3
      visit wiki_path(private_wiki)
      expect(page).to have_content(private_wiki.title)
    end
  end
end
