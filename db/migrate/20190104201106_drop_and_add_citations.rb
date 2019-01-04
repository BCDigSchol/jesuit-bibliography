class DropAndAddCitations < ActiveRecord::Migration[5.2]
  def change
    drop_table :citations

    create_table :citations do |t|
      t.text :name
      
      t.references :bibliography, foreign_key: true
      t.references :person, foreign_key: true
    end
  end
end
