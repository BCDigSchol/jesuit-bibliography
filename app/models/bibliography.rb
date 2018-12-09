class Bibliography < ApplicationRecord
    has_many :comments, inverse_of: :bibliography, dependent: :destroy
    has_many :languages, inverse_of: :bibliography, dependent: :destroy
    has_many :reviewed_components, inverse_of: :bibliography, dependent: :destroy

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
    has_many :translators, class_name: 'Citation', foreign_key: 'translator_id',  inverse_of: 'translator', dependent: :destroy
    has_many :performers, class_name: 'Citation', foreign_key: 'performer_id',  inverse_of: 'performer', dependent: :destroy
    has_many :translated_authors, class_name: 'Citation', foreign_key: 'translated_author_id', inverse_of: 'translated_author', dependent: :destroy

    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :comments_rejectable?
    accepts_nested_attributes_for :languages, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :reviewed_components, allow_destroy: true, reject_if: :all_blank
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
    accepts_nested_attributes_for :translators, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :performers, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :translated_authors, reject_if: :citations_rejectable?, allow_destroy: true

    validates :reference_type, presence: true
    # some records will not have a title
    # validates :title, presence: true

    searchable do
        integer :id

        # reference_type is a required field
        text :reference_type
        text :reference_type_faceting, :as => 'reference_type_facet'

        text :title do
            title if self.title.present?
        end

        text :title_of_review do
            title_of_review if self.title_of_review.present?
        end

        text :chapter_title do
            chapter_title if self.chapter_title.present?
        end

        string :sort_title do  # for sorting by title, ignoring leading A/An/The
            title.downcase.gsub(/^(an?|the)/, '') if self.title.present?
        end

        text :year_published do
            year_published if self.year_published.present?
        end
        
        text :display_title do
            display_title if self.display_title.present?
        end
        
        text :display_year do
            title if self.title.present?
        end
        
        text :display_author do
            display_author if self.display_author.present?
        end
        
        text :place_published do
            place_published if self.place_published.present?
        end

        text :place_published_faceting, :as => 'place_published_facet'
        
        text :publisher do
            publisher if self.publisher.present?
        end
        
        text :volume do
            volume if self.volume.present?
        end
        
        # be sure 'number_of_volumes_text' is defined as a 'text_general' field type in solr's managed-schema file
        text :number_of_volumes do
            number_of_volumes if self.number_of_volumes.present?
        end
        
        text :edition do
            edition if self.edition.present?
        end
        
        text :date do
            date if self.date.present?
        end
        
        text :reprint_edition do
            reprint_edition if self.reprint_edition.present?
        end
        
        text :abstract do
            abstract if self.abstract.present?

        end
        
        text :translated_title do
            translated_title if self.translated_title.present?
        end
        
        text :volume_number do
            volume_number if self.volume_number.present?
        end
        
        text :worldcat_url do
            worldcat_url if self.worldcat_url.present?
        end
        
        text :publisher_url do
            publisher_url if self.publisher_url.present?
        end
        
        text :leuven_url do
            leuven_url if self.leuven_url.present?
        end
        
        text :multimedia_dimensions do
            multimedia_dimensions if self.multimedia_dimensions.present?
        end
        
        text :multimedia_series do
            multimedia_series if self.multimedia_series.present?
        end
        
        text :multimedia_type do
            multimedia_type if self.multimedia_type.present?
        end
        
        text :multimedia_url do
            multimedia_url if self.multimedia_url.present?
        end
        
        text :event_title do
            event_title if self.event_title.present?
        end
        
        text :event_location do
            event_location if self.event_location.present?
        end
        
        text :event_institution do
            event_institution if self.event_institution.present?
        end
        
        text :event_date do
            event_date if self.event_date.present?
        end
        
        text :event_panel_title do
            event_panel_title if self.event_panel_title.present?
        end
        
        text :event_url do
            event_url if self.event_url.present?
        end
        
        text :dissertation_university do
            dissertation_university if self.dissertation_university.present?
        end
        
        text :dissertation_thesis_type do
            dissertation_thesis_type if self.dissertation_thesis_type.present?
        end
        
        text :dissertation_university_url do
            dissertation_university_url if self.dissertation_university_url.present?
        end
        
        # be sure 'number_of_pages_text' is defined as a 'text_general' field type in solr's managed-schema file
        text :number_of_pages do
            number_of_pages if self.number_of_pages.present?
        end
        
        text :journal_title do
            journal_title if self.journal_title.present?
        end
        
        text :issue do
            issue if self.issue.present?
        end
        
        text :page_range do
            page_range if self.page_range.present?
        end
        
        text :epub_date do
            epub_date if self.epub_date.present?
        end
        
        text :chapter_number do
            chapter_number if self.chapter_number.present?
        end
        
        text :book_title do
            book_title if self.book_title.present?
        end
        
        text :paper_title do
            paper_title if self.paper_title.present?
        end
        
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
        text :comments_public

        text :reviewed_components do     # for associations
            reviewed_components.map { |rc| "#{rc.reviewed_author}||#{rc.reviewed_title}" }
        end
        
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

    # public method called from associated models to initiate a Solr reindex of this Bib record
    def reindex_me
        #puts "Bibliography ##{self.id} is reindexed\n\n"
        Sunspot.index! [self]
    end

    private
        def comments_json
            if self.comments.present?
                out = []
                #out << self.comments.map { |comment| { :body => comment.body, :comment_type => comment.comment_type, :commenter => comment.commenter} }
                self.comments.each do |comment|
                    out << comment
                end
                out.to_json
            end
        end

        def comments_public
            if self.comments.present?
                public_comments = []
                out = nil
                self.comments.each do |comment|
                    if comment.body.present? and comment.make_public == true
                        public_comments << comment.body
                    end
                end

                # check if the array contains any elements
                if !public_comments.empty?
                    out = public_comments.join('||')
                end

                out
            end
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