require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:admin_user)   { create(:admin_user) }
  let(:premium_user) { create(:premium_user) }
  let(:user)         { create(:user) }

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  context 'relationships' do
    it { should belong_to(:user) }
    it { should have_many(:colaborators) }
    it { should have_many(:users).through(:colaborators) }
  end

  context 'private wiki\'s' do
    it 'can be created successfully by premium users' do
      premium_user_private_wiki = build(:private_wiki, user: premium_user)
      expect(premium_user_private_wiki.valid?).to eq(true)
    end

    it 'can be created successfully by admin users' do
      admin_user_private_wiki = build(:private_wiki, user: admin_user)
      expect(admin_user_private_wiki.valid?).to eq(true)
    end

    it 'cannot be created by standard users' do
      user_private_wiki = build(:private_wiki, user: user)
      expect(user_private_wiki.valid?).to eq(false)
      expect(user_private_wiki.errors.full_messages
        .include?('Private wikis cannot be created by a standard user'))
        .to eq(true)
    end
  end

  context 'Wiki#public_wikis' do
    scenario 'returns a list of all public wikis' do
      create(:wiki)
      create(:private_wiki)
      create(:wiki)
      expect(Wiki.public_wikis.count).to eq(2)
    end
  end

  context 'Wiki#list_private_wikis_for' do
    it 'returns all private wikis for a user' do
      create(:wiki, user: premium_user)
      private_wiki = create(:private_wiki, user: premium_user)
      wikis = Wiki.list_private_wikis_for(premium_user)
      expect(wikis.count).to eq(1)
      expect(wikis[0]).to eq(private_wiki)
    end
  end

  context 'Wiki#user_wikis_to_public' do
    it 'changes all of a users private wikis to public wikis' do
      create(:private_wiki, user: premium_user)
      Wiki.user_wikis_to_public(premium_user)
      expect(Wiki.first.private).to eq(false)
    end
  end

  it "delets all wiki colaborators if the wiki is deleted" do
    wiki = create(:private_wiki, user: premium_user)
    create(:colaborator, user: user, wiki: wiki)
    expect{wiki.destroy!}.to change{Colaborator.count}.from(1).to(0)
  end
end
