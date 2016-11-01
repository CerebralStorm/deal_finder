class Lead < ApplicationRecord
  has_many :trust_deeds
  has_many :liens
  has_one :parcel

  before_save :set_type

  def set_type
    self.type = 'DeathCertificateLead' if self.document_type == 'DEATHC'
    self.type = 'NoticeOfDeafualtLead' if self.document_type == 'NT DF'
  end

  def parcel_entries
    return [] unless parcel.present?
    parcel.parcel_entries
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
