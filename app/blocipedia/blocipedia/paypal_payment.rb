# Public: Class to handle payments that use the paypal REST API for upgrading 
# a users account to premium status.
class Blocipedia::PaypalPayment
  require 'paypal-sdk-rest'
  include PayPal::SDK::REST
  
  attr_reader   :payment_urls, :payment, :sale
  attr_accessor :cancel_url, :return_url, :payment_id, :payer_id, :sale_id
  
  def initialize(init_hash = {})
    @payment_id =   init_hash[:payment_id]
    @payer_id =     init_hash[:payer_id]
    @cancel_url =   init_hash[:cancel_url]
    @return_url =   init_hash[:return_url]
    @sale_id =      init_hash[:sale_id]
    @payment_urls = {}
    @payment =      nil
    @sale =         nil
  end
  
  # Public: Creates the payment for the default amount of $15 US for the
  # blocipedia upgrade. It returns true if the payment was created successfully
  # or false otherwise. It also sets the return and cancel urls in the
  # payment_urls hash. @return_url and @cancel_url must be set
  #
  # Examples
  #
  #   example = Blocipedia::PaypalPayment.new(
  #     return_url: http://example.com/approve,
  #     cancel_url: http://example.com/cancel)
  #   example.ceate_default_upgrade_payment
  #   # => true
  #
  # Returns true if successful and false otherwise
  def create_default_upgrade_payment
    @payment = Payment.new({
      intent: "sale",

      # Set Paypal as payment method
      payer: {
        payment_method: "paypal"
      },

      # Set transaction items and totals
      transactions: [{
        item_list: {
          items: [{
            name:     "Blocipedia Upgrade",
            price:    "15.00",
            currency: "USD",
            quantity: "1"
          }]
        },
        amount: {
          total: "15.00",
          currency: "USD"
        },
        description: "Upgrade Blocipedia Account"
      }],

      # Urls to redirect the user to after they aprove or cancel the order
      redirect_urls: {
        return_url: @return_url,
        cancel_url: @cancel_url
      }
    })
    
    if @payment.create
      @payment_urls[:approval_url] = @payment.links.find {|v| v.method == "REDIRECT" }.href
      @payment_id = @payment.id
      true
    else
      false
    end
  end
  
  # Public: Finds a Paypal payment using the payment_id. @payment_id must be
  # set for this to complete successfully
  #
  # Examples
  # 
  #   example = Blocipedia::PaypalPayment.new(payment_id: 'PAY786767654')
  #   example.find_payment
  #   # => paypal payment object
  #
  # Returns paypal payment Object
  def find_payment
    @payment = Payment.find(@payment_id)
  end
  
  # Public: Finds a sale object from paypal
  #
  # Examples
  #
  #   example = Blocipedia::PaypalPayment.new(sale_id: 'cdscdscs4343')
  #   example.find_sale
  #   # => paypal sale object
  #
  # Returns an object representing a paypal sale
  def find_sale
    @sale = Sale.find(@sale_id)
  end
  
  # Public: Executes an approved payment
  #
  # Returns sales_id if successful and false otherwise
  def payment_execute
    if @payment.execute(payer_id: @payer_id)
      @sale_id = @payment.transactions[0].related_resources[0].sale.id
    else
      false
    end
  end
  
  # Public: Refunds a completed sale
  #
  # Returns true if successful and false otherwise
  def refund_payment
    refund = @sale.refund({})
    refund.success?
  end
end