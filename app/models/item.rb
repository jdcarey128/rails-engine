class Item < ApplicationRecord
  validates_presence_of :name, :unit_price

  belongs_to :merchant
  has_many :invoice_items 
  has_many :invoices, through: :invoice_items 
end
