require 'rails_helper'
require 'support/sign_in_user'

feature 'Destroy wiki' do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:wiki)  { create(:wiki, user: user1) }

  context 'is successful' do
    scenario 'when you created the wiki' do
      sign_in_user(user1)
      visit wiki_path(wiki.id)
      click_link 'Delete'

      expect(page).to have_content('The wiki was deleted successfully.')
      expect(Wiki.count).to eq(0)
    end
  end

  context 'is unsuccessful' do
    scenario 'When you try to delete some one elses wiki' do
      sign_in_user(user2)
      visit wiki_path(wiki.id)

      expect(page).not_to have_content('Delete')
    end
  end
end
