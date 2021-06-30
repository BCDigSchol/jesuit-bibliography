class CreateThesisTypeSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :thesis_type_suggestions do |t|
      t.text :name
      t.text :note
      t.text :created_by
      t.text :modified_by
      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
