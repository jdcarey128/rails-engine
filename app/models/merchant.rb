class Merchant < ApplicationRecord
  validates_presence_of :name 
  
  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :customers, through: :invoices
end
