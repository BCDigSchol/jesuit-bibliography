class Journal < ControlledVocabularyTerm
    has_many :bibliography_journals, dependent: :destroy
    has_many :bibliographies, through: :bibliography_journals

    after_save :reindex_parent!

    validates :name, presence: true

end
