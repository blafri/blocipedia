require 'rails_helper'
require 'support/sign_in_user'

feature 'Downgrade account to standard' do
  let(:user) { create(:user) }
  let(:premium_user) { create(:premium_user) }

  scenario 'is successful', js: true do
    sign_in_user(user)
    click_on user.email
    click_on 'Upgrade Account'
    click_on 'create-charge'
    click_on 'Pay with my PayPal account'
    fill_in 'login_email', with: ENV['PAYPAL_USER']
    fill_in 'login_password', with: ENV['PAYPAL_PASSWORD']
    click_button 'submitLogin'
    expect(page).to have_content('Review your information', wait: 20)
    click_on 'continue'
    click_on 'Place Order'
    expect(page).to have_content('Your account was successfully upgraded',
                                 wait: 20)
    click_on 'Downgrade Account'

    expect(page).to have_content('Your account has been successfully '\
        'downgraded and your money refunded.', wait: 20)
    expect(User.first.role).to eq('standard')
    expect(User.first.paypal_sale_id).to eq(nil)
  end

  scenario 'all user wikis are converted to public' do
    create(:private_wiki, user: premium_user)
    sale = double('sale', find_sale: true, refund_payment: true)
    allow(Blocipedia::PaypalPayment).to receive(:new).and_return(sale)

    sign_in_user(premium_user)
    click_on premium_user.email
    click_on 'Downgrade Account'

    expect(page).to have_content('Your account has been successfully '\
        'downgraded and your money refunded.')
    expect(Wiki.list_private_wikis_for(User.first).count).to eq(0)
  end

  scenario 'all colaborators for this wikis are removed from colaborators table' do
    private_wiki = create(:private_wiki, user: premium_user)
    create(:colaborator, wiki: private_wiki, user: user)
    sale = double('sale', find_sale: true, refund_payment: true)
    allow(Blocipedia::PaypalPayment).to receive(:new).and_return(sale)

    sign_in_user(premium_user)
    click_on premium_user.email
    click_on 'Downgrade Account'

    expect(page).to have_content('Your account has been successfully '\
                                 'downgraded and your money refunded.')
    expect(Wiki.first.users.count).to eq(0)
  end
end
