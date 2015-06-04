class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    payment = Blocipedia::PaypalPayment.new(return_url: upgrade_url, cancel_url: upgrade_url(order_status: 'canceled'))
    
    if payment.create_default_upgrade_payment
      redirect_to payment.payment_urls[:approval_url]
    else
      flash.now[:error] = "There was a problem processing the payment. Please try again later<br>#{payment.payment.error.message}".html_safe
      render :index
    end
  end
  
  def create
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
end