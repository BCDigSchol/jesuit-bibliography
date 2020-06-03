require 'progress_bar'

namespace :controlled_vocabulary do
  desc "Add normalized names to controlled vocabulary terms"
  task add_normal_names: :environment do

    # Update for each kind of controlled vocabulary term.
    update_normalized_names Entity
    update_normalized_names Journal
    update_normalized_names Language
    update_normalized_names Location
    update_normalized_names Person
    update_normalized_names Period
    update_normalized_names Subject

    puts " All done now!"
  end
end

# Add normalized names to a table
#
# @param [Class] controlled_vocab the relation class to update
def update_normalized_names(controlled_vocab)
  objects = controlled_vocab.where.not(sort_name: nil)
  puts "Updating #{objects.count} #{controlled_vocab.name} objects...\n\n"

  # Normalized name is computed from sort name before every save,
  # so we just need to touch the object.
  objects.each do |object|
    object.save
  end
end