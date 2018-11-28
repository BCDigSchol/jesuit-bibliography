class AddTitleOfReviewToBibliographies < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :title_of_review, :text
  end
end
