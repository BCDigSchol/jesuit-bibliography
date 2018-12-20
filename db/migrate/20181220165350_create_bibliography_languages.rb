class CreateBibliographyLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliography_languages do |t|
      t.belongs_to :language, index: true
      t.belongs_to :bibliography, index: true
      t.timestamps
    end

    add_column :languages, :sort_name, :text
    add_column :languages, :created_by, :text
    add_column :languages, :modified_by, :text
    
    remove_reference :bibliographies, :language, index: true
  end
end
