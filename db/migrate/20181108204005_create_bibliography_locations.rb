class CreateBibliographyLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_locations do |t|
      t.belongs_to :location, index: true
      t.belongs_to :bibliography, index: true
      t.timestamps
    end
  end
end
