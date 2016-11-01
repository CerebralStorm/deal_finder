class CreateParcelEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :parcel_entries do |t|
      t.integer :parcel_id
      t.string :number
      t.string :book
      t.string :page
      t.string :instrument_type
      t.string :recorded_date
      t.string :first_party
      t.string :second_party
      t.string :consideration

      t.timestamps
    end
  end
end
