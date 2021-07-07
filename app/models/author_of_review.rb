class AuthorOfReview < ApplicationRecord
  include BibliographyRefresh

  belongs_to :bibliography, optional: true
  belongs_to :person, optional: true

  after_destroy :reindex_parent!
end
