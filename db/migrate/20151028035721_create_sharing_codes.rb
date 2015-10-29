class CreateSharingCodes < ActiveRecord::Migration
  def change
    create_table :sharing_codes do |t|
      t.string :code

      t.boolean :expires
      t.datetime :expiry_date

      t.belongs_to :room, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end

    remove_column :rooms, :share_id
    remove_column :rooms, :share_link
  end
end
