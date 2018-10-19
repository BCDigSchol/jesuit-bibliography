class CreateBibliographies < ActiveRecord::Migration[5.2]
  def change
    create_table :bibliographies do |t|
      t.text :reference_type

      t.text :year_published
      t.text :title
      t.text :title_secondary
      t.text :place_published
      t.text :publisher
      t.text :volume
      t.text :number_of_volumes
      t.text :pages
      t.text :section
      t.text :title_tertiary
      t.text :edition
      t.text :date
      t.text :type_of_work
      t.text :reprint_edition
      t.text :abstract
      t.text :title_translated
      t.text :language

      t.timestamps
    end
  end
end