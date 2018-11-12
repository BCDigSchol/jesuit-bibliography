class AddFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :volume_number, :text
    add_column :bibliographies, :worldcat_url, :text
    add_column :bibliographies, :secondary_url, :text
    add_column :bibliographies, :leuven_url, :text
    add_column :bibliographies, :multimedia_dimensions, :text
  end
end
