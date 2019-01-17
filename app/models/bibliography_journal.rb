class BibliographyJournal < ApplicationRecord
    belongs_to :bibliography, optional: true
    belongs_to :journal, optional: true

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
