class BibliographyEntity < ApplicationRecord
    belongs_to :bibliography
    belongs_to :entity

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
end
