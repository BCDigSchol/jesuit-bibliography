class BibliographyLocation < ApplicationRecord
    belongs_to :bibliography
    belongs_to :location
end
