require 'rails_helper'
require 'support/sign_in_user'

feature 'Colaborators' do
  let(:user) { create(:user) }
  let(:premium_user) { create(:premium_user) }
  let(:private_wiki) { create(:private_wiki, user: premium_user) }
  let(:wiki) { create(:wiki, user: user) }

  context 'current colaborators' do
    scenario 'are not visable on public wikis' do
      sign_in_user user
      visit edit_wiki_path(wiki)
      expect(page).not_to have_content('Colaborators')
    end

    scenario 'are visable on private wikis if the user is the owner' do
      create(:colaborator, user: user, wiki: private_wiki)
      sign_in_user premium_user
      visit edit_wiki_path(private_wiki)
      expect(page).to have_content('Colaborators')
      expect(page).to have_content(user.email)
    end

    scenario 'is not visable on private wikis if the user is not the owner' do
      create(:colaborator, user: user, wiki: private_wiki)
      sign_in_user user
      visit edit_wiki_path(private_wiki)
      expect(page).to have_content(private_wiki.title)
      expect(page).not_to have_content('Colaborators')
    end
  end

  context 'add colaborators' do
    before do
      sign_in_user premium_user
      visit edit_wiki_path(private_wiki)
    end

    scenario 'is successful if the value entered is a valid user' do
      fill_in 'colaborator_email', with: user.email
      click_button 'Add Colaborator'
      expect(page).to have_content("#{user.email} successfully added as a colaborator")
      expect(Wiki.first.users[0]).to eq(user)
    end

    scenario 'fails if the user is already a colaborator' do
      create(:colaborator, user: user, wiki: private_wiki)
      fill_in 'colaborator_email', with: user.email
      click_button 'Add Colaborator'
      expect(page).to have_content("#{user.email} is already a colaborator")
    end

    scenario 'fails if user does not exist' do
      fill_in 'colaborator_email', with: 'non-existant@example.com'
      click_button 'Add Colaborator'
      expect(page).to have_content('on-existant@example.com does not exist')
      expect(Wiki.first.users.count).to eq(0)
    end
  end

  context 'delete colaborators' do
    scenario 'is successfull' do
      create(:colaborator, user: user, wiki: private_wiki)
      sign_in_user premium_user
      visit edit_wiki_path(private_wiki)
      click_on "Remove"
      expect(page).to have_content('Colaborator was deleted successfully')
      expect(private_wiki.users.empty?).to eq(true)
    end
  end
end
