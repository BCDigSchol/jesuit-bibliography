class AddMultimediaFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :multimedia_series, :text
    add_column :bibliographies, :multimedia_type, :text
    add_column :bibliographies, :multimedia_url, :text
  end
end
