class CreateStandardIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :standard_identifiers do |t|
      t.text :id_type
      t.text :value

      t.timestamps
    end
  end
end
