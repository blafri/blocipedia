require 'rails_helper'
require 'support/sign_in_user'

feature "View" do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:wiki)  { create(:wiki, user: user1) }
  
  context "public wiki" do
    scenario "when not logged in is successful" do
      visit wiki_path(wiki)
      expect(page).to have_content(wiki.title)
    end
    
    scenario "when logged in as creator of wiki" do
      sign_in_user(user1)
      visit wiki_path(wiki)
      expect(page).to have_content(wiki.title)
    end
    
    scenario "when logged in as a user who is not the creator of the wiki" do
      sign_in_user(user2)
      visit wiki_path(wiki)
      expect(page).to have_content(wiki.title)
    end
  end
end