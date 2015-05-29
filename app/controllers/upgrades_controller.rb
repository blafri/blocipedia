class UpgradesController < ApplicationController
  def show
    if current_user.role == 'premium'
      flash[:notice] = "Your account has already been upgraded to a premium account."
      redirect_to edit_user_registration_path
    end
    
    if request.query_parameters['order_status'] == 'canceled'
      flash.now[:error] = 'Your order was canceled'
    end
  end
end