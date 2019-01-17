class BibliographyPeriod < ApplicationRecord
    belongs_to :bibliography, optional: true
    belongs_to :period, optional: true

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
