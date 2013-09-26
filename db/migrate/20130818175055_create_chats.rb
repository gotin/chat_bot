class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :name
      t.text :text

      t.timestamps
    end
  end
end
