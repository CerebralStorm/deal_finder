class CreateLiens < ActiveRecord::Migration[5.0]
  def change
    create_table :liens do |t|
      t.integer :amount
      t.integer :lead_id

      t.timestamps
    end
  end
end
