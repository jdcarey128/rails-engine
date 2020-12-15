class Item < ApplicationRecord
  validates_presence_of :name, :unit_price

  belongs_to :merchant
  has_many :invoice_items 
  has_many :invoices, through: :invoice_items 

  def self.find_item(param)
    key = param.keys[0] 
    if key == 'name' || key == 'description'
      Item.find_by("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      Item.find_by("#{key} >= ?", param[key])
    else
      Item.find_by("#{key} = ? ", param[key])
    end
  end

  def self.find_all(param)
    key = param.keys[0] 
    if key == 'name' || key == 'description'
      Item.where("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      Item.where("#{key} >= ?", param[key])
    else
      Item.where("#{key} = ? ", param[key])
    end
  end
end
