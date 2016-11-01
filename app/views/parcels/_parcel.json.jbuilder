json.extract! parcel, :id, :number, :address, :acres, :land_value, :building_value, :total_value, :created_at, :updated_at
json.url parcel_url(parcel, format: :json)