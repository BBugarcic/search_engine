class CreateDescribings < ActiveRecord::Migration[5.0]
  def change
    create_table :describings do |t|
      t.belongs_to :description, foreign_key: true
      t.belongs_to :product, foreign_key: true

      t.timestamps
    end
  end
end
