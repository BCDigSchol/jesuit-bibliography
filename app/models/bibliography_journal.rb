class BibliographyJournal < ApplicationRecord
    belongs_to :bibliography
    belongs_to :journal

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
