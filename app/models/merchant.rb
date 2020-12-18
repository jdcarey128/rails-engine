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
    select = 'merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue'
    order = 'revenue DESC'
    most(select, order, limit)
  end

  def self.most_items(limit)
    select = 'merchants.*, sum(invoice_items.quantity) as total_items_sold'
    order = 'total_items_sold DESC'
    most(select, order, limit)
  end

  def self.most(select, order, limit)
    select(select)
      .joins(invoices: %i[invoice_items transactions])
      .merge(Transaction.successful)
      .merge(Invoice.shipped)
      .group(:id)
      .order(order)
      .limit(limit)
  end

  def self.total_revenue(start_date, end_date)
    joins(invoices: %i[invoice_items transactions])
      .merge(Transaction.successful)
      .merge(Invoice.shipped)
      .where('invoices.created_at >= ? AND invoices.created_at <= ?', "#{start_date} 00:00:00", "#{end_date} 24:00:00")
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.merchant_revenue(merchant_id)
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .joins(invoices: %i[invoice_items transactions])
      .where('merchants.id = ?', merchant_id)
      .merge(Invoice.shipped)
      .merge(Transaction.successful)
      .group(:id)
  end
end
