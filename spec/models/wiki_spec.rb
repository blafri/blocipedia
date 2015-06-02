require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:admin_user)   { create(:admin_user) }
  let(:user)         { create(:user) }
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should belong_to(:user) }
  
  context "private wiki's" do
    it "can be created successfully by premium users" do
      wiki = build(:private_wiki)
      expect(wiki.valid?).to eq(true)
    end
    
    it "can be created successfully by admin users" do
      wiki = build(:private_wiki, user: admin_user)
      expect(wiki.valid?).to eq(true)
    end
    
    it "cannot be created by standard users" do
      wiki = build(:private_wiki, user: user)
      expect(wiki.valid?).to eq(false)
      expect(wiki.errors.full_messages.
        include?("Private wikis cannot be created by a standard user")).
        to eq(true)
    end
  end
  
  context "#wikis_visable_to" do
    before do
      create(:wiki)
      create(:private_wiki)
    end
    
    it "returns all wikis if a user is logged in" do
      expect(Wiki.wikis_visable_to(user).count).to eq(2)
    end
    
    it "returns only public wikis if a user is not logged in" do
      expect(Wiki.wikis_visable_to(nil).count).to eq(1)
    end
  end
end
