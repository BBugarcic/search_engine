class Describing < ApplicationRecord
  belongs_to :description
  belongs_to :product

  def self.similar_product_ids_and_counts(product)
    description_ids = product.descriptions.pluck(:id)
    # group product ids and count number of common attributes
    where.not(product_id: product.id) # do not compare with itself
    .where(:description_id => description_ids) # take only rows with relevant descriptions
    .group("product_id")
    .order("count(description_id) desc")
    .limit(5)
    .pluck("product_id", "count(description_id)")
  end
end
