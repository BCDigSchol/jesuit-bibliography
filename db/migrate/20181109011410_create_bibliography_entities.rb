class CreateBibliographyEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_entities do |t|
      t.belongs_to :entity, index: true
      t.belongs_to :bibliography, index: true
      t.timestamps
    end
  end
end
