class BibliographySubject < ApplicationRecord
    belongs_to :bibliography, optional: true
    belongs_to :subject, optional: true

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
