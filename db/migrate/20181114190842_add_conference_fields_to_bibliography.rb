class AddConferenceFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :event_title, :text
    add_column :bibliographies, :event_location, :text
    add_column :bibliographies, :event_institution, :text
    add_column :bibliographies, :event_date, :text
    add_column :bibliographies, :event_panel_title, :text
    add_column :bibliographies, :event_url, :text
  end
end
