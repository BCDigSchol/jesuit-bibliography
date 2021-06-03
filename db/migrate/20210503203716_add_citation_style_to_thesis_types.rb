class AddCitationStyleToThesisTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :thesis_types, :citation_style, :text
  end
end
