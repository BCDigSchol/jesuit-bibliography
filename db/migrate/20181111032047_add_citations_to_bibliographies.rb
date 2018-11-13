class AddCitationsToBibliographies < ActiveRecord::Migration[5.2]
  def change
    change_table :citations do |t|
      t.references :author
      t.references :editor
      t.references :author_of_review
      t.references :reviewed_author
      t.references :translator
      t.references :performer
      t.references :translated_author
    end
  end
end