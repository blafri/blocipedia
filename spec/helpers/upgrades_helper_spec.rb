require 'rails_helper'

RSpec.describe UpgradesHelper, type: :helper do
  context '#set_upgrades_page_title' do
    it 'successfully outputs the right title when user creates new payment' do
      params_hash = {}
      allow(helper).to receive(:params).and_return(params_hash)
      expect(helper.set_upgrades_page_title).to eq('Upgrade your account')
    end

    it 'successfully outputs the right title when user confirms payment' do
      params_hash = { paymentId: 'test', PayerID: 'test' }
      allow(helper).to receive(:params).and_return(params_hash)
      expect(helper.set_upgrades_page_title).to eq('Confirm Payment')
    end
  end

  context '#set_payment_link' do
    it 'successfully sets the correct link when user creating new payment' do
      params_hash = {}
      expected_link = '<a id="create-charge" href="/charge/new">'\
        '<img src="https://www.paypalobjects.com/en_US/i/btn/x-click-but6.gif"'\
        ' alt="X click but6" /></a>'
      allow(helper).to receive(:params).and_return(params_hash)
      expect(helper.set_payment_link).to eq(expected_link)
    end

    it 'successfully sets the correct link when user confirming payment' do
      params_hash = { paymentId: 'test', PayerID: 'test' }
      expected_link = '<a class="btn btn-success" rel="nofollow" data-method='\
        '"post" href="/charge?PayerID=test&amp;paymentId=test">Place Order</a>'
      allow(helper).to receive(:params).and_return(params_hash)
      expect(helper.set_payment_link).to eq(expected_link)
    end
  end
end
