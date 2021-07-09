class ThesisType < ControlledVocabularyTerm
  #belongs_to :bibliography, optional: true

  has_many :bibliography_thesis_types
  has_many :bibliographies, through: :bibliography_thesis_types

  after_save :reindex_parents!

  validates :name, presence: true
  validates :citation_style, presence: true
  
end
