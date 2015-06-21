class CreateColaborators < ActiveRecord::Migration
  def change
    create_table :colaborators do |t|
      t.references :user, index: true, foreign_key: true
      t.references :wiki, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :colaborators, [:user_id, :wiki_id], unique: true
  end
end
