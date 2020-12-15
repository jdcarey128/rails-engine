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
      Merchant.find_by("#{key} >= ? AND #{key} <= ?", param[key], within_12_hours)
    else
      Merchant.find_by("#{key} = ? ", param[key])
    end
  end

  def self.find_all(param)
    key = param.keys[0]
    if key == 'name'
      Merchant.where("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      Merchant.where("#{key} >= ? AND #{key} <= ?", param[key], within_12_hours).limit(20)
    else
      Merchant.where("#{key} = ? ", param[key])
    end
  end

  private 
    def self.within_12_hours 
      (Time.now.utc + 0.5.day).to_s 
    end

end
