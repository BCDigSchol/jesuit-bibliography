class CreateBibliographyPeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_periods do |t|
      t.belongs_to :period, index: true
      t.belongs_to :bibliography, index: true
      t.timestamps
    end
  end
end
