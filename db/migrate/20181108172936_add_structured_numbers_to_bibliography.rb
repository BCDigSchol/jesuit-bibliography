class AddStructuredNumbersToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :isbn, :string
    add_column :bibliographies, :issn, :string
    add_column :bibliographies, :doi, :string
  end
end
