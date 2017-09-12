require_relative 'merchant'
require 'csv'

class MerchantRepository 
  attr_accessor :all

  def initialize(file_path, parent=nil)
    @all    = create_merchants(file_path)
    @parent = parent
  end

  def csv_parse(file_path)
    CSV.open file_path, headers: true, header_converters: :symbol
  end

  def create_merchants(file_path)
    csv_parse(file_path).map {|row| Merchant.new(row)}
  end

  def find_by_id(id_number)
    all.find {|merchant| merchant.id.to_i == id_number.to_i}
  end

  def find_by_name(name)
    all.find {|merchant| merchant.name.downcase == name.downcase}
  end

  def find_all_by_name(fragment)
    all.select {|merchant| merchant.name.downcase.include?(fragment.downcase)}
  end
end