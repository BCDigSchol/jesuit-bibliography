class CreateBibliographySubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_subjects do |t|
      t.belongs_to :subject, index: true
      t.belongs_to :bibliography, index: true
      t.timestamps
    end
  end
end
