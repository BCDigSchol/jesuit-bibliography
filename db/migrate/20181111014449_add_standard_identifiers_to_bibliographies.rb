class AddStandardIdentifiersToBibliographies < ActiveRecord::Migration[5.2]
  def change
    change_table :standard_identifiers do |t|
      t.references :isbn
      t.references :issn
      t.references :doi
    end
  end
end
