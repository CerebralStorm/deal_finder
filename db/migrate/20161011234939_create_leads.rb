class CreateLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :leads do |t|
      t.string :entry_number
      t.date :filing_date
      t.string :deceased
      t.string :address
      t.string :parcel_number
      t.string :document_type
      t.string :city
      t.string :zip
      t.string :heir
      t.string :contact_info
      t.integer :assessed_value
      t.integer :zillow_value

      t.timestamps
    end
  end
end
