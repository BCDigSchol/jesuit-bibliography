class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.text :name
      t.text :sort_name
      t.text :display_name
      t.text :birth_date
      t.text :death_date

      t.timestamps
    end
  end
end
