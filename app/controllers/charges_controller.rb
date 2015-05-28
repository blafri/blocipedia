class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.role == 'premium'
      flash[:notice] = "Your account has already been upgraded to a premium account."
      redirect_to edit_user_registration_path
    end
    
    if request.query_parameters['order_status'] == 'canceled'
      flash.now[:error] = 'Your order was canceled'
    end
  end
  
  def create
    payment = Blocipedia::PaypalPayment.new(return_url: upgrade_confirm_payment_url, cancel_url: upgrade_url(order_status: 'canceled'))
    
    if payment.create_default_upgrade_payment
      redirect_to payment.payment_urls[:approval_url]
    else
      flash.now[:error] = "There was a problem processing the payment. Please try again later<br>#{payment.payment.error.message}".html_safe
      render :index
    end
  end
  
  def confirm_payment
    @payment_id = params[:paymentId]
    @payer_id =   params[:PayerID]
  end
  
  def make_payment
    # Check to make sure GET parameters are present
    if !params.include?(:paymentId)
      flash[:error] = "No payment id found."
      redirect_to upgrade_path
    end
    
    if !params.include?(:PayerID)
      flash[:error] = "No payer id found."
      redirect_to upgrade_path
    end
    
    payment = Blocipedia::PaypalPayment.new(payment_id: params[:paymentId], payer_id: params[:PayerID])
    payment.find_payment
    
    if payment.payment_execute
      current_user.update_attributes(role: 'premium', paypal_sale_id: payment.sale_id)
      flash[:notice] = "Your account was successfully upgraded."
      redirect_to edit_user_registration_path
    else
      flash[:error] = "The payment was not successful. Please try again. #{payment.payment.error.message}"
      redirect_to upgrade_path
    end
  end
  
  def refund_payment
    if current_user.role != 'premium'
      flash[:error] = 'Your account is already a standard account'
      redirect_to edit_user_registration_path
    end
    
    sale = Blocipedia::PaypalPayment.new(sale_id: current_user.paypal_sale_id)
    sale.find_sale
    
    if sale.refund_payment
      current_user.update_attributes(role: 'standard', paypal_sale_id: nil)
      flash[:notice] = 'Your account has been successfully downgraded and your money refunded.'
      redirect_to edit_user_registration_path
    else
      flash[:error] = 'There was a problem downgrading your account. Please try again.'
      redirect_to edit_user_registration_path
    end
  end
end