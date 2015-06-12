require 'rails_helper'

RSpec.describe User, type: :model do
  let(:admin_user) { build(:admin_user) }
  let(:premium_user) { build(:premium_user) }
  let(:user) { build(:user) }

  context 'relationships' do
    it { should have_many(:wikis) }
    it { should have_many(:colaborators) }
  end

  it 'should set the role on newly created users to standard by default' do
    expect(User.new.role).to eq('standard')
  end

  context '#create_private_wikis?' do
    it 'should return true if user\'s role is \'admin\'' do
      expect(admin_user.create_private_wikis?).to eq(true)
    end

    it 'should return true if user\'s role is \'premium\'' do
      expect(premium_user.create_private_wikis?).to eq(true)
    end

    it 'should return false if user\'s role is \'standard\'' do
      expect(user.create_private_wikis?).to eq(false)
    end
  end

  it 'removes user as a colaborator on all wikis if user is deleted' do
    wiki = create(:private_wiki, user: premium_user)
    create(:colaborator, user: user, wiki: wiki)
    create(:colaborator, user: admin_user, wiki: wiki)
    expect{user.destroy!}.to change{wiki.users.count}.from(2).to(1)
  end

  context '#list_accessible_wikis' do
    before do
      create(:wiki, user: user)
      create(:private_wiki, user: premium_user)
      create(:wiki, user: premium_user)
      create(:private_wiki, user: admin_user)
      create(:private_wiki)
      create(:colaborator, user: user)
      create(:colaborator, user: premium_user)
    end

    it 'shows correct wikis for standard user' do
      expect(user.list_accessible_wikis.count).to eq(3)
    end

    it 'shows correct wikis for premium user' do
      expect(premium_user.list_accessible_wikis.count).to eq(4)
    end

    it 'shows correct wikis for admin user' do
      expect(admin_user.list_accessible_wikis.count).to eq(7)
    end
  end
end
