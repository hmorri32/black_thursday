require_relative 'transactions'
require 'csv'

class TransactionRepository
  attr_reader :all,
              :parent

  def initialize(file_path, parent = nil)
    @all = from_csv(file_path).map { |transaction| Transaction.new(transaction, self) }
    @parent = parent
  end

  def from_csv(file_path)
    CSV.open file_path, headers: true, header_converters: :symbol
  end

  def find_by_id(id)
    all.find { |transaction| transaction.id == id.to_i}
  end

  def find_all_by_invoice_id(invoice_id)
    all.select { |transaction| transaction.invoice_id == invoice_id}
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.select { |transaction| transaction.credit_card_number == credit_card_number}
  end

  def find_all_by_result(result)
    all.select { |transaction| transaction.result == result}
  end

  def inspect
    "#{self.class}"
  end
end
