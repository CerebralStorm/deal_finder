class LobWorker
  attr_accessor :client, :lead, :parcel, :params

  def initialize(params)
    @client = Lob::Client.new(api_key: api_key, api_version: "2016-06-30")
    @params = params
  end

  def api_key
    'test_f468da512f7e7616a41ee7cebfcaf97aafb'
  end

  def send_letter
    client.letters.create(
      description: "Demo Letter",
      to: {
        name: params[:name],
        address_line1: params[:address],
        address_city: params[:city],
        address_state: params[:state],
        address_country: params[:country],
        address_zip: params[:zip]
      },
      from: {
        name: "Nick Reedy",
        address_line1: "9663 South Candle Tree Ln",
        address_city: "Sandy",
        address_state: "UT",
        address_country: "US",
        address_zip: "84092"
      },
      file: params[:html],
      data: data,
      color: false
    )
  end

  def data
    result = {}
    LobLetter::ATTRIBUTES.each do |field|
      result[field] = params[field]
    end
    result
  end

end