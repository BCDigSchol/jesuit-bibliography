class CreateJournals < ActiveRecord::Migration[5.2]
  def change
    create_table :journals do |t|
      t.text :name
      t.text :sort_name
      t.text :display_name
      t.text :created_by
      t.text :modified_by

      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
