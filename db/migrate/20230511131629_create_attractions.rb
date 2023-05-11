class CreateAttractions < ActiveRecord::Migration[6.1]
  def change
    create_table :attractions do |t|
      t.integer :api_id
      t.string :name
      t.text :introduction
      t.string :zipcode
      t.string :district
      t.string :address
      t.string :images_src

      t.timestamps
    end
  end
end
