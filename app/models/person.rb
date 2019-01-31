class Person < ApplicationRecord
    has_many :authors
    has_many :bibliographies, through: :authors

    has_many :editors
    has_many :bibliographies, through: :editors

    has_many :translators
    has_many :bibliographies, through: :translators

    has_many :translated_authors
    has_many :bibliographies, through: :translated_authors

    has_many :book_editors
    has_many :bibliographies, through: :book_editors

    has_many :author_of_reviews
    has_many :bibliographies, through: :author_of_reviews

    has_many :performers
    has_many :bibliographies, through: :performers

    after_save :reindex_parent!

    # Define form hints here
    PERSON_FIELD_HINT = 'Last name, First name'.freeze
    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze

    def reindex_parent!
        self.author_of_reviews.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end

        self.authors.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end

        self.editors.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end

        self.translators.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end

        self.translated_authors.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end

        self.book_editors.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end

        self.performers.each do |bs|
            puts "\n\nReindexing #{bs.bibliography.id}..."
            bs.bibliography.reindex_me
        end
    end

    validates :name, presence: true
end
