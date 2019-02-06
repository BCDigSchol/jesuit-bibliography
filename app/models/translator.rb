class Translator < ApplicationRecord
  belongs_to :bibliography, optional: true
  belongs_to :person, optional: true

  after_destroy :reindex_parent!

  private
    def reindex_parent!
      puts "\n\nDeleting Translator...\n\n"
      bibliography.reindex_me if bibliography.present?
    end
end
