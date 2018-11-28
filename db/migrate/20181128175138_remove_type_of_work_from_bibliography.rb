class RemoveTypeOfWorkFromBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :type_of_work, :text
  end
end
