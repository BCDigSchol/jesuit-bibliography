class BibliographyEntity < ApplicationRecord
    belongs_to :bibliography
    belongs_to :entity
end
