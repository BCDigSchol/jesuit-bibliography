class CreateSeriesMultimedia < ActiveRecord::Migration[5.2]
  def change
    create_table :series_multimedia do |t|
      t.text :name
      t.text :created_by
      t.text :modified_by

      t.references :bibliography, foreign_key: true

      t.timestamps
    end

    remove_column :bibliographies, :multimedia_series, :text
  end
end
