require 'rails_helper'

RSpec.describe Colaborator, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki) }

  context 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:wiki) }
  end

  it 'can be successfully saved' do
    expect(Colaborator.create(wiki: wiki, user: user)).not_to eq(false)
    expect(Colaborator.first.user_id).to eq(user.id)
    expect(Colaborator.first.wiki_id).to eq(wiki.id)
  end

  context 'validations' do
    it 'duplicate record are not allowed' do
      create(:colaborator, user: user, wiki: wiki)
      colaborator = build(:colaborator, user: user, wiki: wiki)
      expect(colaborator.save).to eq(false)
      error_message = 'User is already a colaborator'
      expect(colaborator.errors.full_messages.first).to eq(error_message)
    end

    it 'fails when the user does not exist' do
      colaborator = Colaborator.new(wiki: wiki, user_id: 78)
      expect(colaborator.save).to eq(false)
      error_message = 'User does not exist'
      expect(colaborator.errors.full_messages.first).to eq(error_message)
    end

    it 'fails when the wiki does not exist' do
      colaborator = Colaborator.new(wiki_id: 87, user_id: user)
      expect(colaborator.save).to eq(false)
      error_message = 'Wiki does not exist'
      expect(colaborator.errors.full_messages.first).to eq(error_message)
    end
  end
end
