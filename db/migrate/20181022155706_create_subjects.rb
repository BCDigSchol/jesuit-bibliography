class CreateSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :subjects do |t|
      t.text :term_type
      t.text :name

      t.timestamps
    end
  end
end
