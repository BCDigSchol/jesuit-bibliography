class CreateStandardIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :standard_identifiers do |t|
      t.text :value

      t.timestamps
    end
  end
end
