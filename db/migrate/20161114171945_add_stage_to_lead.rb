class AddStageToLead < ActiveRecord::Migration[5.0]
  def change
    add_column :leads, :lead_stage_id, :integer
  end
end
