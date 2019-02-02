class AddImageToFeaturedRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :featuredrecords, :image, :text
  end
end
