class CreateTrustDeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :trust_deeds do |t|
      t.integer :amount
      t.integer :lead_id

      t.timestamps
    end
  end
end
