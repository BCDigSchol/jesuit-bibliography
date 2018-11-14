class AddBookReviewFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :reviewed_title, :text
  end
end
