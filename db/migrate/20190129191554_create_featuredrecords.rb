class CreateFeaturedrecords < ActiveRecord::Migration[5.2]
  def change
    create_table :featuredrecords do |t|
      t.text :name
      t.text :body
      t.integer :rank
      t.boolean :published

      t.text :created_by
      t.text :modified_by

      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
