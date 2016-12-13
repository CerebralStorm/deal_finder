class Lead < ApplicationRecord
  SUCCESS_STATUS = 'success'
  FAILURE_STATUS = 'failure'
  EXPIRED_STATUS = 'expired'
  belongs_to :lead_stage
  has_many :trust_deeds
  has_many :liens
  has_one :parcel
  has_many :parcel_entries, through: :parcel

  before_save :set_type

  scope :by_type, -> (type) { where(type: type) }
  scope :by_stage, -> (lead_stage) { where(lead_stage_id: lead_stage) }
  scope :visible, -> { where(hidden: false) }
  scope :needs_scraping, -> { where(scrape_status: [nil, FAILURE_STATUS]) }

  def complete_scrape
    self.update_attributes(scrape_status: SUCCESS_STATUS)
  end

  def fail_scrape
    self.update_attributes(scrape_status: FAILURE_STATUS, scrape_attempts: (self.scrape_attempts || 0) + 1)
    self.update_attributes(scrape_status: EXPIRED_STATUS) if self.scrape_attempts > 2
  end

  def set_type
    self.type = 'DeathCertificateLead' if self.document_type == 'DEATHC'
    self.type = 'NoticeOfDefaultLead' if self.document_type == 'NT DF'
  end

  def reconveyance_count
    return 0 unless parcel.present?
    parcel_entries.reconveyance.count
  end

  def trust_deed_count
    return 0 unless parcel.present?
    parcel_entries.trust_deed.count
  end

  def address
    return unless parcel.present?
    parcel.address
  end

  def full_address
    [(parcel.try(:address) || address), city, zip].compact.join(', ')
  end

  def deceased_pretty
    first = self.deceased.split(',')[1]
    last = self.deceased.split(',')[0]
    "#{first} #{last}".titleize
  end

  def loan_to_value
    return unless parcel.present?
    parcel.loan_to_value
  end
end
