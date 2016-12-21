class Parcel < ApplicationRecord
  belongs_to :lead
  has_many :parcel_entries

  def owner_pretty
    first = self.owner.split(',')[1]
    last = self.owner.split(',')[0]
    "#{first} #{last}".titleize.strip
  end

  def value
    self.total_value || self.land_value + self.building_value
  end

  def loan
    parcel_entry = parcel_entries.trust_deed.last
    return unless parcel_entry.present?
    return unless parcel_entry.consideration.present?
    amount = parcel_entry.consideration.split('.')[0]
    amount.scan(/\d/).join('').to_i
  end

  def loan_to_value
    return unless value.present?
    (loan.to_f / value.to_f) * 100
  end

  def city
    result = Indirizzo::Address.new(owner_address).city
    result = result.kind_of?(Array) ? result.first : result
    result.try(:titleize)
  end

  def state
    result = Indirizzo::Address.new(owner_address).state
    result.kind_of?(Array) ? result.first : result
  end

  def zip
    result = Indirizzo::Address.new(owner_address).zip
    result.kind_of?(Array) ? result.first : result
  end
end
