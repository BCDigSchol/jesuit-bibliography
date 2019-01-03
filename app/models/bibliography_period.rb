class BibliographyPeriod < ApplicationRecord
    belongs_to :bibliography
    belongs_to :period

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
