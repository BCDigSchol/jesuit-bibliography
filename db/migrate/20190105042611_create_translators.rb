class CreateTranslators < ActiveRecord::Migration[5.2]
  def change
    create_table :translators do |t|
      t.references :bibliography, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
