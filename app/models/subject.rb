class Subject < ControlledVocabularyTerm
    has_many :bibliography_subjects, dependent: :destroy
    has_many :bibliographies, through: :bibliography_subjects

    after_save :reindex_parent!

    validates :name, presence: true
    #validates :sort_name, presence: true
end
