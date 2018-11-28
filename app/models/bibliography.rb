class Bibliography < ApplicationRecord
    has_many :comments, inverse_of: :bibliography, dependent: :destroy
    has_many :languages, inverse_of: :bibliography, dependent: :destroy

    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects, inverse_of: :bibliography, dependent: :destroy
    has_many :subjects, through: :bibliography_subjects

    # many-to-many relationship through bibliography_periods
    has_many :bibliography_periods, inverse_of: :bibliography, dependent: :destroy
    has_many :periods, through: :bibliography_periods

    # many-to-many relationship through bibliography_locations
    has_many :bibliography_locations, inverse_of: :bibliography, dependent: :destroy
    has_many :locations, through: :bibliography_locations

    # many-to-many relationship through bibliography_entities
    has_many :bibliography_entities, inverse_of: :bibliography, dependent: :destroy
    has_many :entities, through: :bibliography_entities

    # relationship using class_name and foreign_key atributes
    has_many :isbns, class_name: 'StandardIdentifier', foreign_key: 'isbn_id', inverse_of: 'isbn', dependent: :destroy
    has_many :issns, class_name: 'StandardIdentifier', foreign_key: 'issn_id', inverse_of: 'issn', dependent: :destroy
    has_many :dois,  class_name: 'StandardIdentifier', foreign_key: 'doi_id',  inverse_of: 'doi', dependent: :destroy

    # relationship using class_name and foreign_key atributes
    has_many :authors, class_name: 'Citation', foreign_key: 'author_id', inverse_of: 'author', dependent: :destroy
    has_many :editors, class_name: 'Citation', foreign_key: 'editor_id', inverse_of: 'editor', dependent: :destroy
    has_many :book_editors, class_name: 'Citation', foreign_key: 'book_editor_id', inverse_of: 'book_editor', dependent: :destroy
    has_many :author_of_reviews, class_name: 'Citation', foreign_key: 'author_of_review_id', inverse_of: 'author_of_review', dependent: :destroy
    has_many :reviewed_authors, class_name: 'Citation', foreign_key: 'reviewed_author_id', inverse_of: 'reviewed_author', dependent: :destroy
    has_many :translators, class_name: 'Citation', foreign_key: 'translator_id',  inverse_of: 'translator', dependent: :destroy
    has_many :performers, class_name: 'Citation', foreign_key: 'performer_id',  inverse_of: 'performer', dependent: :destroy
    has_many :translated_authors, class_name: 'Citation', foreign_key: 'translated_author_id', inverse_of: 'translated_author', dependent: :destroy

    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :comments_rejectable?
    accepts_nested_attributes_for :languages, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :bibliography_subjects, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_periods, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_locations, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_entities, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :isbns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :issns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :dois, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :authors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :editors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :book_editors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :author_of_reviews, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :reviewed_authors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :translators, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :performers, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :translated_authors, reject_if: :citations_rejectable?, allow_destroy: true

    validates :reference_type, presence: true
    validates :title, presence: true

    searchable do
        integer :id
        text :reference_type
        text :reference_type_faceting, :as => 'reference_type_facet'
        text :title, :default_boost => 2
        string :title
        string :sort_title do  # for sorting by title, ignoring leading A/An/The
            title.downcase.gsub(/^(an?|the)/, '')
        end
        text :year_published
        text :place_published
        text :place_published_faceting, :as => 'place_published_facet'
        text :publisher
        text :volume
        # be sure 'number_of_volumes_text' is defined as a 'text_general' field type in solr's managed-schema file
        text :number_of_volumes
        text :edition
        text :date
        text :type_of_work
        text :reprint_edition
        text :abstract
        text :title_translated
        text :volume_number
        text :worldcat_url
        text :secondary_url # rename to publisher_url
        text :leuven_url
        text :multimedia_dimensions
        text :multimedia_series
        text :multimedia_type
        text :multimedia_url
        text :event_title
        text :event_location
        text :event_institution
        text :event_date
        text :event_panel_title
        text :event_url
        text :dissertation_university
        text :dissertation_thesis_type
        text :dissertation_university_url
        # be sure 'number_of_pages_text' is defined as a 'text_general' field type in solr's managed-schema file
        text :number_of_pages
        text :journal_title
        text :issue
        text :page_range
        text :epub_date
        text :reviewed_title
        text :chapter_number
        text :book_title
        
        text :authors do     # for associations
            authors.map { |author| author.display_name }
        end
        text :editors do     # for associations
            editors.map { |editor| editor.display_name }
        end
        text :book_editors do     # for associations
            book_editors.map { |book_editor| book_editor.display_name }
        end
        text :author_of_reviews do     # for associations
            author_of_reviews.map { |author_of_review| author_of_review.display_name }
        end
        text :reviewed_authors do     # for associations
            reviewed_authors.map { |reviewed_author| reviewed_author.display_name }
        end
        text :translators do     # for associations
            translators.map { |translator| translator.display_name }
        end
        text :performers do     # for associations
            performers.map { |performer| performer.display_name }
        end
        text :translated_authors do     # for associations
            translated_authors.map { |translated_author| translated_author.display_name }
        end

        text :languages do     # for associations
            languages.map { |language| language.name }
        end
        text :languages_faceting, :as => 'languages_facet'

        text :comments do     # for associations
            comments.map { |comment| "#{comment.comment_type}||#{comment.body}||#{comment.commenter}" }
        end
        text :comments_json
        
        text :isbns do     # for associations
            isbns.map { |isbn| isbn.value }
        end
        text :issns do     # for associations
            issns.map { |issn| issn.value }
        end
        text :dois do     # for associations
            dois.map { |doi| doi.value }
        end
        text :subjects do     # for associations
            subjects.map { |subject| subject.name }
        end
        text :subjects_faceting, :as => 'subjects_facet'

        text :locations do     # for associations
            locations.map { |location| location.name }
        end
        text :locations_faceting, :as => 'locations_facet'

        text :entities do     # for associations
            entities.map { |entity| entity.name }
        end
        text :entities_faceting, :as => 'entities_facet'

        text :periods do     # for associations
            periods.map { |period| period.name }
        end
        text :periods_faceting, :as => 'periods_facet'
        
        time :created_at
        time :updated_at
    end

    private
        def comments_json
            out = []
            if self.comments.present?
                #out << self.comments.map { |comment| { :body => comment.body, :comment_type => comment.comment_type, :commenter => comment.commenter} }
                self.comments.each do |comment|
                    out << comment
                end
            end
            out.to_json
        end

        def reference_type_faceting
            self.reference_type
        end

        def place_published_faceting
            self.place_published
        end

        def languages_faceting
            languages.map { |language| language.name }
        end

        def periods_faceting
            self.periods.map { |period| period.name }
        end

        def subjects_faceting
            self.subjects.map { |subject| subject.name }
        end

        def locations_faceting
            self.locations.map { |location| location.name }
        end

        def entities_faceting
            self.entities.map { |entity| entity.name }
        end

        def comments_rejectable?(comment)
            comment['body'].blank?
        end

        def citations_rejectable?(citation)
            citation['display_name'].blank?
        end
end