class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :room_id
      t.string :name
      t.string :content

      t.timestamps
    end
  end
end
