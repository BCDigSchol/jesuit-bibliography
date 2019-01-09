class AddMoreFieldsToReviewedComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :reviewed_components, :reviewed_translator, :text
    add_column :reviewed_components, :reviewed_editor, :text
  end
end
