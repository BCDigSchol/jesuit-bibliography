class AddLinkToRecordFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :book_chapter_record_ref, :integer
    add_column :reviewed_components, :reviewed_title_record_ref, :integer
  end
end
