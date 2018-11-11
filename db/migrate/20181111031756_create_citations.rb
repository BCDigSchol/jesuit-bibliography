class CreateCitations < ActiveRecord::Migration[5.2]
  def change
    create_table :citations do |t|
      t.text :display_name
      t.text :surname
      t.text :middlename
      t.text :forename
      t.text :title

      t.timestamps
    end
  end
end
