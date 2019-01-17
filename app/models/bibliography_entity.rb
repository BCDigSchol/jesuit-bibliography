class BibliographyEntity < ApplicationRecord
    belongs_to :bibliography, optional: true
    belongs_to :entity, optional: true

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
