class Location < ControlledVocabularyTerm
    has_many :bibliography_locations, dependent: :destroy
    has_many :bibliographies, through: :bibliography_locations

    after_save :reindex_parents!

    validates :name, presence: true

end
