class Item < ApplicationRecord
  validates_presence_of :name, :unit_price

  belongs_to :merchant
  has_many :invoice_items 
  has_many :invoices, through: :invoice_items 

  def self.find_one(param)
    super(self, param)
  end

  def self.find_all(param)
    super(self, param)
  end
  
end
