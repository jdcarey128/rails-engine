class Item < ApplicationRecord
  validates_presence_of :name, :unit_price

  belongs_to :merchant
  has_many :invoice_items 
  has_many :invoices, through: :invoice_items 

  def self.find_item(param)
    key = param.keys[0] 
    if param[key].instance_of?(String)
      Item.find_by("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    else
      Item.find_by("#{key} = ? ", param[key])
    end
  end
end
