class CreatePersonSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :person_suggestions do |t|
      t.text :name
      t.text :note
      t.text :field_name
      t.text :created_by
      t.text :modified_by
      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
