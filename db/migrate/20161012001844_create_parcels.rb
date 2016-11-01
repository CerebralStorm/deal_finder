class CreateParcels < ActiveRecord::Migration[5.0]
  def change
    create_table :parcels do |t|
      t.string :number
      t.string :address
      t.string :owner
      t.string :owner_address
      t.float :acres
      t.integer :land_value
      t.integer :building_value
      t.integer :total_value
      t.integer :lead_id

      t.timestamps
    end
  end
end
