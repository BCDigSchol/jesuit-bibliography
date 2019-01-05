class DropCitations < ActiveRecord::Migration[5.2]
  def change
    drop_table :citations
  end
end
