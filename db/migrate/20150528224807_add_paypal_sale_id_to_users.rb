# Public: This migration adds the paypal_sale_id column to the users tables
class AddPaypalSaleIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paypal_sale_id, :string
  end
end
