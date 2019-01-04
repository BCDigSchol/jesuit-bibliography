class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.text :name
      t.text :surname
      t.text :middlename
      t.text :forename
      t.text :title

      t.text :created_by
      t.text :modified_by

      t.timestamps
    end
  end
end
