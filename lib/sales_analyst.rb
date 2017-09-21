require 'bigdecimal'
require 'bigdecimal/util'
require_relative './modules/require_helper'

class SalesAnalyst
  include Arithmetic
  include ItemAnalyst
  include InvoiceAnalyst
  include RevenueAnalyst
  include MerchantAnalyst

  attr_reader :engine

  def initialize(engine)
    @engine = engine
  end

  def average_items_per_merchant
    ItemAnalyst.average_items_per_merchant(merchants)
  end

  def average_items_per_merchant_standard_deviation
    ItemAnalyst.average_items_per_merchant_standard_deviation(merchants)
  end

  def merchants_with_high_item_count
    ItemAnalyst.merchants_with_high_item_count(merchants)
  end

  def average_item_price_for_merchant(merchant_id)
    ItemAnalyst.average_item_price_for_merchant(merchant_id, engine)
  end

  def average_average_price_per_merchant
    ItemAnalyst.average_average_price_per_merchant(merchants, engine)
  end

  def golden_items
    ItemAnalyst.golden_items(items)
  end

  def average_invoices_per_merchant
    InvoiceAnalyst.average_invoices_per_merchant(merchants)
  end

  def average_invoices_per_merchant_standard_deviation
    InvoiceAnalyst.average_invoices_per_merchant_standard_deviation(merchants)
  end
  
  def top_merchants_by_invoice_count
    InvoiceAnalyst.top_merchants_by_invoice_count(merchants)
  end

  def bottom_merchants_by_invoice_count
    InvoiceAnalyst.bottom_merchants_by_invoice_count(merchants)
  end

  def top_days_by_invoice_count
    InvoiceAnalyst.top_days_by_invoice_count(invoices)
  end

  # def invoice_std_deviation(invoices_per_day)
  #   Math.sqrt(invoices_per_day.map do |total|
  #     (total - avg_inv_per_day)**2
  #   end.sum / 7).round
  # end

  # def invoices_per_day
    # grouped_invoices.values.map(&:length)
  # end

  # def day_array
  #   grouped_invoices.keys.zip(invoices_per_day)
  # end

  # def days_with_high_invoices(day_array, avg_inv_per_day, deviation)
  #   day_array.select do |invoice|
  #     invoice[1] > avg_inv_per_day + deviation
  #   end.map(&:first)
  # end

  # def grouped_invoices
  #   invoices.group_by {|invoice|invoice.created_at.strftime("%A")}
  # end

  # def avg_inv_per_day
  #   invoices.length / 7
  # end

  # def invoice_status(status)
  #   total     = invoices.length
  #   selected  = invoices.select {|invoice| invoice.status == status}
  #   ((selected.length.to_f / total.to_f) * 100.0).round(2)
  # end

  # def total_revenue_by_date(date)
  #   date = date.to_s.split(" ")[0]
  #   arr  = invoices.select {|item| item.created_at.to_s.split(" ")[0] == date}
  #   arr.map(&:total).sum
  # end

  # def top_revenue_earners(x = 20)
  #   merchants.sort_by do |merchant|
  #     revenue_by_merchant(merchant.id)
  #   end.reverse.shift(x)
  # end

  # def revenue_by_merchant(id)
  #   invoices = engine.merchants.find_invoices_by_merchant_id(id)
  #   invoices.reduce(0) {|sum, invoice| sum += invoice.total}
  # end

  # def merchants_ranked_by_revenue
  #   top_revenue_earners(merchants.length)
  # end

  # def merchants_with_pending_invoices
  #   merchants.select {|merchant| pending_invoices?(merchant)}
  # end

  # def pending_invoices?(merchant)
  #   merchant.invoices.any? {|invoice| !invoice.is_paid_in_full?}
  # end

  # def merchants_with_only_one_item
  #   merchants.select {|merchant| merchant.items.count == 1}
  # end

  # def merchants_with_only_one_item_registered_in_month(month)
  #   merchants_by_month(month) & merchants_with_only_one_item
  # end

  # def merchants_by_month(month)
  #   merchants.select {|m| m.created_at.strftime("%B") == month.capitalize}
  # end

  # def id_and_total_quantity_of_item(merchant_id)
  #   inv = completed_invoices(engine.find_invoices_by_merchant_id(merchant_id))
  #   inv.flat_map(&:invoice_items).reduce({}) do |hash, inv_item|
  #     hash[inv_item.item_id]  = 0 if !hash[inv_item.item_id]
  #     hash[inv_item.item_id] += inv_item.quantity
  #     hash
  #   end
  # end

  # def pending?(invoice)
  #   invoice.transactions.all? { |t| t.result == "failed" }
  # end

  # def completed_invoices(invoices)
  #   invoices.reject {|invoice| pending?(invoice)}
  # end

  # def most_sold_item_for_merchant(merchant_id)
  #   top_items(merchant_id).keys.map{|id| engine.find_item_by_id(id)}
  # end

  # def top_items(merchant_id)
  #   top_quantity = item_quantity(merchant_id).max_by {|i, q| q}
  #   item_quantity(merchant_id).select {|i, q| q == top_quantity[1]}
  # end

  # def item_quantity(merchant_id)
  #   items_sorted(merchant_id).reduce({}) do |hash, element|
  #     hash[element[0]]  = element[1] if !hash[element[0]]
  #     hash[element[0]] += element[1]
  #     hash
  #   end
  # end

  # def items_sorted(merchant_id)
  #   id_and_total_quantity_of_item(merchant_id).sort_by(&:last).reverse
  # end

  # def best_item_for_merchant(merchant_id)
  #   item_id = revenue(merchant_id).max_by {|i, r| r}.first
  #   engine.find_item_by_id(item_id)
  # end

  # def revenue(merchant_id)
  #   paid_invoices(merchant_id).reduce({}) do |hash, item|
  #     build_revenue_hash(hash, item)
  #   end
  # end

  # def paid_invoices(merchant_id)
  #   engine.merchants
  #         .find_by_id(merchant_id)
  #         .invoices
  #         .flat_map {|inv| inv.invoice_items if inv.is_paid_in_full?}
  #         .compact
  # end

  # def build_revenue_hash(hash, item)
  #   if hash[item.item_id]
  #      hash[item.item_id] += item.quantity * item.unit_price
  #   else
  #      hash[item.item_id]  = item.quantity * item.unit_price
  #   end
  #  hash
  # end

  private
  def items
    engine.items.all
  end

  def invoices
    engine.invoices.all
  end

  def merchants
    engine.merchants.all
  end

  def customers
    engine.customers.all
  end
end