require 'rails_helper'
require 'support/sign_in_user'

feature 'Wiki index page' do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:premium_user) { create(:premium_user) }
  let!(:wiki) { create(:wiki, user: user) }
  let!(:private_wiki) { create(:private_wiki, user: premium_user) }
  let!(:private_wiki_2) { create(:private_wiki) }
  let!(:private_wiki_3) { create(:private_wiki)}

  scenario 'shows only wikis that are not private if user not logged in' do
    visit wikis_path
    expect(page).to have_content(wiki.title)
    expect(page).not_to have_content(private_wiki.title)
  end

  scenario 'shows all wikis if the user is logged in as an admin' do
    sign_in_user(admin_user)
    visit wikis_path
    expect(page).to have_content(wiki.title)
    expect(page).to have_content(private_wiki.title)
    expect(page).to have_content(private_wiki_2.title)
    expect(page).to have_content(private_wiki_3.title)
  end

  scenario 'show only private wikis where I am either a colaborator or owner' do
    create(:colaborator, wiki: private_wiki_2, user: premium_user)
    sign_in_user(premium_user)
    visit wikis_path
    expect(page).to have_content(wiki.title)
    expect(page).to have_content(private_wiki.title)
    expect(page).to have_content(private_wiki_2.title)
    expect(page).not_to have_content(private_wiki_3.title)
  end
end
