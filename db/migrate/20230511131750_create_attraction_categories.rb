class CreateAttractionCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :attraction_categories do |t|
      t.integer :attraction_id
      t.integer :attraction_api_id
      t.integer :category_api_id
      t.string :name

      t.timestamps
    end
  end
end
