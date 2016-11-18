class CreateLeadStages < ActiveRecord::Migration[5.0]
  def change
    create_table :lead_stages do |t|
      t.string :name

      t.timestamps
    end
  end
end
