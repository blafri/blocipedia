module UpgradesHelper
  def set_upgrades_page_title
    if params.include?(:paymentId) && params.include?(:PayerID)
      'Confirm Payment'
    else
      'Upgrade your account'
    end
  end
  
  def set_payment_link
    if params.include?(:paymentId) && params.include?(:PayerID)
      link_to("Place Order",
        charge_path(PayerID: params[:PayerID], paymentId: params[:paymentId], ),
        method: :post, class: 'btn btn-success')
    else
      link_to(new_charge_path, id: "create-charge") do
        image_tag('https://www.paypalobjects.com/en_US/i/btn/x-click-but6.gif')
      end
    end
  end
end