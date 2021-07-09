class Entity < ControlledVocabularyTerm
    has_many :bibliography_entities, dependent: :destroy
    has_many :bibliographies, through: :bibliography_entities

    after_save :reindex_parents!

    def to_label
        self.display_name
    end

    validates :name, presence: true

end
