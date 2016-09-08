class Product < ApplicationRecord
  has_many :describings
  has_many :descriptions, through: :describings

  validates :descriptions, :length => {:minimum => 3}

  def all_descriptions=(labels)
    self.descriptions = labels.split(",").map do |label|
      Description.where(label: label.strip).first_or_create!
    end
  end

  def all_descriptions
    self.descriptions.map(&:label).join(", ")
  end

end
