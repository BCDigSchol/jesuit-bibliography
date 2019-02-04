class AuthorOfReview < ApplicationRecord
  belongs_to :bibliography, optional: true
  belongs_to :person, optional: true

  after_destroy :reindex_parent!

  private
    def reindex_parent!
      puts "\n\nDeleting Author of Review...\n\n"
      bibliography.reindex_me
    end
end
