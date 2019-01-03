class BibliographyLanguage < ApplicationRecord
    belongs_to :bibliography
    belongs_to :language

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
