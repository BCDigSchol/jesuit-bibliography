class CreateThesisTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :thesis_types do |t|
      t.text :name
      t.text :sort_name
      t.text :normal_name
      t.text :created_by
      t.text :modified_by
      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
