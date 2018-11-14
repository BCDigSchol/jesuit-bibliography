class AddDissertationFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :dissertation_university, :text
    add_column :bibliographies, :dissertation_thesis_type, :text
    add_column :bibliographies, :dissertation_university_url, :text
    add_column :bibliographies, :number_of_pages, :text
  end
end
