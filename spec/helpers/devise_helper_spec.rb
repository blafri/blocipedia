require 'rails_helper'

RSpec.describe DeviseHelper, type: :helper do
  let(:premium_user)  { build(:premium_user) }
  let(:standard_user) { build(:user) }
  
  context "#account_upgrade_link" do
    scenario "displays correct link for premium user" do
      expect(helper.account_upgrade_link(premium_user)).
        to eq("<a class=\"btn btn-success\" id=\"upgrade-account-link\" rel=\"nofollow\" data-method=\"post\" href=\"#{refund_path}\">Downgrade Account</a>")
    end
    
    scenario "displays correct link for standard user" do
      expect(helper.account_upgrade_link(standard_user)).
        to eq("<a class=\"btn btn-success\" id=\"upgrade-account-link\" href=\"#{upgrade_path}\">Upgrade Account</a>")
    end
  end
end