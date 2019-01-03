class BibliographyLocation < ApplicationRecord
    belongs_to :bibliography
    belongs_to :location

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
