class Person < ControlledVocabularyTerm
    has_many :authors, dependent: :destroy
    has_many :bibliographies, through: :authors

    has_many :editors, dependent: :destroy
    has_many :bibliographies, through: :editors

    has_many :translators, dependent: :destroy
    has_many :bibliographies, through: :translators

    has_many :book_editors, dependent: :destroy
    has_many :bibliographies, through: :book_editors

    has_many :author_of_reviews, dependent: :destroy
    has_many :bibliographies, through: :author_of_reviews

    has_many :performers, dependent: :destroy
    has_many :bibliographies, through: :performers

    after_save :reindex_parents!
    after_destroy :process_deletion

    # Define form hints here
    PERSON_FIELD_HINT = 'Last name, First name'.freeze
    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze

    def process_deletion
        #puts "\n\nDeleting Person...\n\n"
        reindex_parents!
    end

    def bib_refs
        bibs = []

        self.author_of_reviews.each do |person|
            bibs.append(person.bibliography) if person.bibliography.present?
        end

        self.authors.each do |person|
            bibs.append(person.bibliography) if person.bibliography.present?
        end

        self.editors.each do |person|
            bibs.append(person.bibliography) if person.bibliography.present?
        end

        self.translators.each do |person|
            bibs.append(person.bibliography) if person.bibliography.present?
        end

        self.book_editors.each do |person|
            bibs.append(person.bibliography) if person.bibliography.present?
        end

        self.performers.each do |person|
            bibs.append(person.bibliography) if person.bibliography.present?
        end

        bibs
    end

    validates :name, presence: true

end
