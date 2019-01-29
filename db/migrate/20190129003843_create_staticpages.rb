class CreateStaticpages < ActiveRecord::Migration[5.2]
  def change
    create_table :staticpages do |t|
      t.text :name
      t.text :slug
      t.text :description
      t.integer :rank
      t.text :body

      t.text :created_by
      t.text :modified_by

      t.timestamps
    end
  end
end
