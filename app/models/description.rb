class Description < ApplicationRecord
  has_many :describings
  has_many :products, through: :describings
end
