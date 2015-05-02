class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name

      t.boolean :public, default: false

      t.boolean :share_link, default: true
      t.string :share_id

      t.uuid :sync_id
      t.uuid :chat_id

      t.timestamps null: false
    end
  end
end
