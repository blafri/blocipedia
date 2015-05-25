require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:wikis) }
  
  it "should set the role on newly created users to standard by default" do
    expect(User.new.role).to eq('standard')
  end
end
