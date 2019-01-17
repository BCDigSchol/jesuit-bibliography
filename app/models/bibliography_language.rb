class BibliographyLanguage < ApplicationRecord
    belongs_to :bibliography, optional: true
    belongs_to :language, optional: true

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
