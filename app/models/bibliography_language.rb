class BibliographyLanguage < ApplicationRecord
    belongs_to :bibliography
    belongs_to :language
end
