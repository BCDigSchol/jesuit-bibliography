class CreateLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :languages do |t|
      t.text :name

      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
