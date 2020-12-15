class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :customers, through: :invoices

  def self.find_merchant(param)
    key = param.keys[0]
    if key == 'name'
      Merchant.find_by("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      Merchant.find_by("#{key} >= ?", param[key])
    else
      Merchant.find_by("#{key} = ? ", param[key])
    end
  end

  def self.find_all(param)
    key = param.keys[0]
    if key == 'name'
      Merchant.where("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      Merchant.where("#{key} >= ?", param[key])
    else
      Merchant.where("#{key} = ? ", param[key])
    end
  end

end
