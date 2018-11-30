class AddPaperTitleToBibliographies < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :paper_title, :text
  end
end
