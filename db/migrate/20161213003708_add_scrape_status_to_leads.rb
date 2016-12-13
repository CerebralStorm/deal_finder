class AddScrapeStatusToLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :leads, :scrape_status, :string
    add_column :leads, :scrape_attempts, :integer, default: 0
    Lead.update_all(scrape_status: 'success')
  end
end
