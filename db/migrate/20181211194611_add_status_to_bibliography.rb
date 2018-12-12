class AddStatusToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :status, :text
  end
end
