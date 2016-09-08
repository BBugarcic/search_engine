class AddPriceCategoryToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :price_category, :integer
  end
end
