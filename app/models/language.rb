class Language < ControlledVocabularyTerm
    has_many :bibliography_languages, dependent: :destroy
    has_many :bibliographies, through: :bibliography_languages

    after_save :reindex_parent!

    validates :name, presence: true

end
