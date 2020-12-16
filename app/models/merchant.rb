class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_one(param)
    super(self, param)
  end

  def self.find_all(param)
    super(self, param)
  end

  def self.most_revenue(limit)
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .merge(Invoice.shipped)
      .group(:id)
      .order('revenue DESC')
      .limit(limit)
  end

  def self.most_items(limit)
    select('merchants.*, sum(invoice_items.quantity) as total_items_sold')
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .merge(Invoice.shipped)
      .group(:id)
      .order('total_items_sold DESC')
      .limit(limit)
  end

  # def self.all_merchant_revenue(_start_date, _end_date)
  #   if start_date == end_date
  #     Merchant.joins(:invoices, :invoice_items, :transactions)
  #             .merge(Transaction.successful).where('DATE(created_at) = ?', start_date)
  #             .sum('invoice_items.quantity * invoice_items.unit_price')
  #   else
  #     Merchant.joins(:invoices, :invoice_items, :transactions)
  #             .merge(Transaction.successful).where('created_at >= ? AND created_at <= ?', start_date, end_date)
  #             .sum('invoice_items.quantity * invoice_items.unit_price')
  #   end
  # end

  # def self.merchant_revenue(merchant_id)
  #   Merchant.select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
  #           .where('merchants.id = ?', merchant_id).joins(:invoices, :invoice_items, :transactions)
  #           .merge(Transaction.successful).group(:id)
  # end
end
