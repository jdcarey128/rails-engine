class Merchant < ApplicationRecord

  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :customers, through: :invoices

  def self.find_one(param)
    super(self, param)
  end

  def self.find_all(param)
    super(self, param)
  end

end
