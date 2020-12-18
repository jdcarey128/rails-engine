class Item < ApplicationRecord
  validates_presence_of :name, :unit_price

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items 

  after_destroy :clean_invoices

  def self.find_one(param)
    super(self, param)
  end

  def self.find_all(param)
    super(self, param)
  end

  private 
    def clean_invoices
      Invoice.clean_invoices 
    end
  
end
