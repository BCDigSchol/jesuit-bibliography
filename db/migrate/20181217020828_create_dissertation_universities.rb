class CreateDissertationUniversities < ActiveRecord::Migration[5.2]
  def change
    create_table :dissertation_universities do |t|
      t.text :name
      t.text :created_by
      t.text :modified_by

      t.references :bibliography, foreign_key: true

      t.timestamps
    end

    remove_column :bibliographies, :dissertation_university, :text
  end
end
