# Public: This migration adds a role column to the users table
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: 'standard'
  end
end
