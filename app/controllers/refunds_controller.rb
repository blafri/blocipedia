class RefundsController < ApplicationController
  def create
    if current_user.role != 'premium'
      flash[:error] = 'Your account is already a standard account'
    else
      sale = Blocipedia::PaypalPayment.new(sale_id: current_user.paypal_sale_id)
      sale.find_sale
      
      if sale.refund_payment
        current_user.update_attributes(role: 'standard', paypal_sale_id: nil)
        flash[:notice] = 'Your account has been successfully downgraded and your money refunded.'
      else
        flash[:error] = 'There was a problem downgrading your account. Please try again.'
      end
    end
    redirect_to edit_user_registration_path
  end
end