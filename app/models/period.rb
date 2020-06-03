class Period < ControlledVocabularyTerm
    has_many :bibliography_periods, dependent: :destroy
    has_many :bibliographies, through: :bibliography_periods

    after_save :reindex_parent!

    validates :name, presence: true

end
