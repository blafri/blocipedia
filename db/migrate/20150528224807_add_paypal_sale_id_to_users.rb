class AddPaypalSaleIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paypal_sale_id, :string
  end
end
