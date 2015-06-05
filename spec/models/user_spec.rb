require 'rails_helper'

RSpec.describe User, type: :model do
  let(:admin_user) { build(:admin_user) }
  let(:premium_user) { build(:premium_user) }
  let(:user) { build(:user) }
  
  it { should have_many(:wikis) }
  
  it "should set the role on newly created users to standard by default" do
    expect(User.new.role).to eq('standard')
  end
  
  context "#create_private_wikis?" do
    it "should return true if user's role is 'admin'" do
      expect(admin_user.create_private_wikis?).to eq(true)
    end
    
    it "should return true if user's role is 'premium'" do
      expect(premium_user.create_private_wikis?).to eq(true)
    end
    
    it "should return false if user's role is 'standard" do
      expect(user.create_private_wikis?).to eq(false)
    end
  end
end
