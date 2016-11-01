class ParcelEntry < ApplicationRecord
  belongs_to :parcel

  default_scope { order(:recorded_date)}

  scope :reconveyance, -> { where(instrument_type: 'RECON') }
  scope :trust_deed, -> { where(instrument_type: ['TRS D', 'TRD']) }

end
