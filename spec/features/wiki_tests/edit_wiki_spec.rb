require 'rails_helper'
require 'support/sign_in_user'

feature "Edit wiki" do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:wiki) { create(:wiki, user: user1) }
  
  context "is successful" do
    scenario "when a user tries to edit his own wiki" do
      sign_in_user(user1)
      visit edit_wiki_path(wiki.id)
      
      # We will try to change the body of the wiki
      fill_in 'wiki_body', with: 'I am changing the body'
      click_button 'Update Wiki'
      
      expect(page).to have_content('Wiki updated successfully')
      expect(Wiki.find(wiki.id).body).to eq('I am changing the body')
    end
    
    scenario "when a user tries to edit someone elses wiki" do
      sign_in_user(user2)
      visit edit_wiki_path(wiki.id)
      
      # We will try to change the body of the wiki
      fill_in 'wiki_body', with: 'I am changing the body'
      click_button 'Update Wiki'
      
      expect(page).to have_content('Wiki updated successfully')
      expect(Wiki.find(wiki.id).body).to eq('I am changing the body')
    end
  end
  
  context "is unsuccessful" do
    scenario "when a user is not signed in" do
      visit edit_wiki_path(wiki.id)
      
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end
end