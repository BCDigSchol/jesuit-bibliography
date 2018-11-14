class AddJournalArticleFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :journal_title, :text
    add_column :bibliographies, :issue, :text
    add_column :bibliographies, :page_range, :text
    add_column :bibliographies, :epub_date, :text
  end
end
