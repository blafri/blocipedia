require 'rails_helper'
require 'support/sign_in_user'

feature 'Wiki index page' do
  let(:user)          { create(:user) }
  let!(:wiki)         { create(:wiki) }
  let!(:private_wiki) { create(:private_wiki) }

  scenario 'shows only wikis that are not private if user not logged in' do
    visit wikis_path
    expect(page).to have_content(wiki.title)
    expect(page).not_to have_content(private_wiki.title)
  end

  scenario 'shows all wikis if the user is logged in' do
    sign_in_user(user)
    visit wikis_path
    expect(page).to have_content(wiki.title)
    expect(page).to have_content(private_wiki.title)
  end
end
