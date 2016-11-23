class AddHiddenToLead < ActiveRecord::Migration[5.0]
  def change
    add_column :leads, :hidden, :boolean, default: false
  end
end
