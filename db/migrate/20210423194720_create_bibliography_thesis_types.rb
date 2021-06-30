class CreateBibliographyThesisTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_thesis_types do |t|
      t.belongs_to :thesis_type, index: true
      t.belongs_to :bibliography, index: true

      t.timestamps
    end
  end
end
