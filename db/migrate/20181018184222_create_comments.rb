class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :commenter
      t.text :body
      t.text :comment_type
      t.boolean :make_public
      t.references :bibliography, foreign_key: true

      t.timestamps
    end
  end
end
