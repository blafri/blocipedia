require 'rails_helper'

RSpec.describe WikisHelper, type: :helper do
  context "#wiki_creator" do
    it "returns username if it is available" do
      wiki = build(:wiki_user_has_username)
      expect(helper.wiki_creator(wiki)).to eq(wiki.user.username)
    end
    
    it "returns email if username is not available" do
      wiki = build(:wiki)
      expect(helper.wiki_creator(wiki)).to eq(wiki.user.email)
    end
  end
  
  context "#wiki_submit_text" do
    scenario "when creating a wiki is correct" do
      expect(helper.wiki_submit_text('new')).to eq('Create Wiki')
    end
    
    scenario "when updating a wiki is correct" do
      expect(helper.wiki_submit_text('edit')).to eq('Update Wiki')
    end
  end
end
