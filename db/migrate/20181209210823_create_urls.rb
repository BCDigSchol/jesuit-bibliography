class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.text :link

      t.references :worldcat_url
      t.references :publisher_url
      t.references :leuven_url
      t.references :multimedia_url
      t.references :event_url
      t.references :dissertation_university_url

      t.timestamps
    end
  end
end