class CreateAuthorOfReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :author_of_reviews do |t|
      t.references :bibliography, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
