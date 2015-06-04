require 'rails_helper'
require 'support/sign_in_user'

feature 'Create a wiki' do
  let(:user) { create(:user) }
  let(:premium_user) { create(:premium_user) }

  context 'private wiki' do
    context 'make wiki private checkbox' do
      scenario 'is not visable for standard users' do
        sign_in_user(user)
        visit new_wiki_path
        expect(page).not_to have_content('Make Wiki Private')
      end

      scenario 'is visable for premium users' do
        sign_in_user(premium_user)
        visit new_wiki_path
        expect(page).to have_content('Make Wiki Private')
      end

      scenario 'can be created successfully' do
        sign_in_user(premium_user)
        visit new_wiki_path
        fill_in 'wiki_title', with: 'Test wiki'
        fill_in 'wiki_body', with: 'This is just a test wiki'
        check 'wiki_private'
        click_button 'Save'

        expect(page).to have_content('New wiki successfully created.')
        expect(Wiki.first.private).to eq(true)
      end
    end
  end

  context 'is successful' do
    scenario 'when logged in' do
      sign_in_user(user)
      visit new_wiki_path
      fill_in 'wiki_title', with: 'Test Wiki'
      fill_in 'wiki_body', with: 'This is just a test wiki'
      click_button 'Save'

      expect(page).to have_content('New wiki successfully created.')
      expect(page).to have_content('Test Wiki')
      expect(Wiki.count).to eq(1)
    end
  end

  context 'is unsuccessful' do
    scenario 'when not logged in' do
      visit new_wiki_path
      expect(page).to have_content('You need to sign in or sign up before '\
          'continuing.')
    end

    scenario 'when title is empty' do
      sign_in_user(user)
      visit new_wiki_path
      fill_in 'wiki_body', with: 'This is just a test wiki'
      click_button 'Save'

      expect(page).to have_content('There was a problem saving your new wiki. '\
          'Please try again.')
      expect(page).to have_content('Title can\'t be blank')
      expect(Wiki.count).to eq(0)
    end

    scenario 'when body is empty' do
      sign_in_user(user)
      visit new_wiki_path
      fill_in 'wiki_title', with: 'Wiki title'
      click_button 'Save'

      expect(page).to have_content('There was a problem saving your new wiki. '\
          'Please try again.')
      expect(page).to have_content('Body can\'t be blank')
      expect(Wiki.count).to eq(0)
    end
  end
end
