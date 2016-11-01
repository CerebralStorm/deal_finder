class AddTypeToLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :leads, :type, :string
  end
end
