class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  scope :shipped, -> { where(status: "shipped") }

  def self.clean_invoices
    select('invoices.*, invoice_items.*')
      .left_outer_joins(:invoice_items)
      .where('invoice_items.id is null')
      .delete_all
  end
end
