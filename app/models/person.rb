class Person < ApplicationRecord
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

    after_save :reindex_parent!
    after_destroy :process_deletion

    # Define form hints here
    PERSON_FIELD_HINT = 'Last name, First name'.freeze
    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze

    def process_deletion
        puts "\n\nDeleting Person...\n\n"
        self.reindex_parent!
    end

    validates :name, presence: true

    private
        def reindex_parent!
            self.author_of_reviews.each do |bs|
                puts "\n\nReindexing ##{bs.bibliography.id} from Person->author_of_review ##{self.id}"
                bs.bibliography.reindex_me
            end

            self.authors.each do |bs|
                puts "\n\nReindexing ##{bs.bibliography.id} from Person->authors ##{self.id}"
                bs.bibliography.reindex_me
            end

            self.editors.each do |bs|
                puts "\n\nReindexing ##{bs.bibliography.id} from Person->editors ##{self.id}"
                bs.bibliography.reindex_me
            end

            self.translators.each do |bs|
                puts "\n\nReindexing ##{bs.bibliography.id} from Person->translators ##{self.id}"
                bs.bibliography.reindex_me
            end

            self.book_editors.each do |bs|
                puts "\n\nReindexing ##{bs.bibliography.id} from Person->book_editors ##{self.id}"
                bs.bibliography.reindex_me
            end

            self.performers.each do |bs|
                puts "\n\nReindexing ##{bs.bibliography.id} from Person->performers ##{self.id}"
                bs.bibliography.reindex_me
            end
        end
end
