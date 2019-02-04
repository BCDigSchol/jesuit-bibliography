class BookEditor < ApplicationRecord
  belongs_to :bibliography, optional: true
  belongs_to :person, optional: true

  after_destroy :reindex_parent!

  private
    def reindex_parent!
      puts "\n\nDeleting Book Editor...\n\n"
      bibliography.reindex_me
    end
end
