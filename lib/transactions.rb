class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :parent

  def initialize(info, parent = nil)
    @id = info[:id]
    @invoice_id = info[:invoice_id]
    @credit_card_number = info[:credit_card_number]
    @credit_card_expiration_date = info[:credit_card_expiration_date]
    @result = info[:result]
    @created_at = Time.parse(info[:created_at])
    @updated_at = Time.parse(info[:updated_at])
  end
end
