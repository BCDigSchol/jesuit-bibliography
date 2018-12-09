class RemoveUrlFieldsFromBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :worldcat_url, :text
    remove_column :bibliographies, :publisher_url, :text
    remove_column :bibliographies, :leuven_url, :text
    remove_column :bibliographies, :multimedia_url, :text
    remove_column :bibliographies, :event_url, :text
    remove_column :bibliographies, :dissertation_university_url, :text
  end
end