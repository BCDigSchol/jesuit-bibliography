class CreateReviewedComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :reviewed_components do |t|
      t.text :reviewed_author
      t.text :reviewed_title

      t.references :bibliography, foreign_key: true

      t.timestamps
    end

    # clean up unnecessary column/table reference
    remove_column :bibliographies, :reviewed_title, :text
    remove_reference :citations, :reviewed_author, index:true
  end
end
