class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_one(object, param)
    key = param.keys[0]
    if key == 'name' || key == 'description'
      object.find_by("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      object.find_by("#{key} >= ? AND #{key} <= ?", param[key], within_12_hours)
    else
      object.find_by("#{key} = ? ", param[key])
    end
  end


  def self.find_all(object, param) 
    key = param.keys[0]
    if key == 'name' || key == 'description'
      object.where("lower(#{key}) like ? ", "%#{param[key].downcase}%")
    elsif param[key].include?('UTC')
      object.where("#{key} >= ? AND #{key} <= ?", param[key], within_12_hours).limit(20)
    else
      object.where("#{key} = ? ", param[key])
    end
  end

  def self.within_12_hours 
    (Time.now.utc + 0.5.day).to_s 
  end
end
