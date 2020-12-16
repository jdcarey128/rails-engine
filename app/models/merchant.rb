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
    Merchant.select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').
      joins(:invoices, :invoice_items, :transactions).merge(Transaction.successful).
      group(:id).order('revenue DESC').limit(limit)
  end

end
