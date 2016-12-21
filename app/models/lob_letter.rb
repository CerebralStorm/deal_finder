class LobLetter
  def self.add_members(*members)
    members.each do |method|
      define_method(method) { @table[method] }
      define_method("#{method}=") { |val| @table[method] = val }
    end
  end

  ATTRIBUTES = [:name, :address, :city, :state, :zip, :deceased, :date, :country]

  add_members *ATTRIBUTES

  attr_accessor :table

  def initialize(fields)
    @table = fields
  end
end