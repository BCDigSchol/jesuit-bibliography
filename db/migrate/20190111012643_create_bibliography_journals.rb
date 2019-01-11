class CreateBibliographyJournals < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_journals do |t|
      t.belongs_to :journal, index: true
      t.belongs_to :bibliography, index: true

      t.timestamps
    end
  end
end
