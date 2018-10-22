class BibliographySubject < ApplicationRecord
    belongs_to :bibliography
    belongs_to :subject
end
