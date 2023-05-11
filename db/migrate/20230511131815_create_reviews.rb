class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :attraction_id
      t.integer :user_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
