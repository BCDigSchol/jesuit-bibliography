class Bibliography < ApplicationRecord
    has_many :comments, inverse_of: :bibliography, dependent: :destroy
    #has_many :languages, inverse_of: :bibliography, dependent: :destroy
    has_many :reviewed_components, inverse_of: :bibliography, dependent: :destroy
    has_many :publishers, inverse_of: :bibliography, dependent: :destroy
    has_many :publish_places, inverse_of: :bibliography, dependent: :destroy
    has_many :dissertation_universities, inverse_of: :bibliography, dependent: :destroy
    has_many :series_multimedium, inverse_of: :bibliography, dependent: :destroy
    has_many :tags, inverse_of: :bibliography, dependent: :destroy
    has_many :subject_suggestions, inverse_of: :bibliography, dependent: :destroy
    has_many :location_suggestions, inverse_of: :bibliography, dependent: :destroy
    has_many :entity_suggestions, inverse_of: :bibliography, dependent: :destroy
    has_many :period_suggestions, inverse_of: :bibliography, dependent: :destroy
    has_many :language_suggestions, inverse_of: :bibliography, dependent: :destroy
    has_many :person_suggestions, inverse_of: :bibliography, dependent: :destroy

    has_many :authors, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :authors

    has_many :editors, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :editors

    has_many :translators, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :translators

    has_many :translated_authors, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :translated_authors

    has_many :book_editors, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :book_editors

    has_many :author_of_reviews, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :author_of_reviews

    has_many :performers, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :performers

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

    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_languages, inverse_of: :bibliography, dependent: :destroy
    has_many :languages, through: :bibliography_languages

    # relationship using class_name and foreign_key atributes
    has_many :isbns, class_name: 'StandardIdentifier', foreign_key: 'isbn_id', inverse_of: 'isbn', dependent: :destroy
    has_many :issns, class_name: 'StandardIdentifier', foreign_key: 'issn_id', inverse_of: 'issn', dependent: :destroy
    has_many :dois,  class_name: 'StandardIdentifier', foreign_key: 'doi_id',  inverse_of: 'doi', dependent: :destroy

    has_many :worldcat_urls, class_name: 'Url', foreign_key: 'worldcat_url_id', inverse_of: 'worldcat_url', dependent: :destroy
    has_many :publisher_urls, class_name: 'Url', foreign_key: 'publisher_url_id', inverse_of: 'publisher_url', dependent: :destroy
    has_many :leuven_urls, class_name: 'Url', foreign_key: 'leuven_url_id', inverse_of: 'leuven_url', dependent: :destroy
    has_many :multimedia_urls, class_name: 'Url', foreign_key: 'multimedia_url_id', inverse_of: 'multimedia_url', dependent: :destroy
    has_many :event_urls, class_name: 'Url', foreign_key: 'event_url_id', inverse_of: 'event_url', dependent: :destroy
    has_many :dissertation_university_urls, class_name: 'Url', foreign_key: 'dissertation_university_url_id', inverse_of: 'dissertation_university_url', dependent: :destroy


    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :comments_rejectable?
    #accepts_nested_attributes_for :languages, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :reviewed_components, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :publishers, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :publish_places, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :dissertation_universities, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :series_multimedium, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :tags, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :subject_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :location_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :entity_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :period_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :language_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :person_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :bibliography_subjects, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_periods, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_locations, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_entities, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_languages, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :isbns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :issns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :dois, reject_if: :all_blank, allow_destroy: true

    accepts_nested_attributes_for :authors, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :editors, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :translators, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :translated_authors, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :book_editors, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :author_of_reviews, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :performers, reject_if: :all_blank, allow_destroy: true

    accepts_nested_attributes_for :worldcat_urls, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :publisher_urls, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :leuven_urls, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :multimedia_urls, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :event_urls, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :dissertation_university_urls, reject_if: :all_blank, allow_destroy: true

    validates :reference_type, presence: true
    # some records will not have a title
    # validates :title, presence: true

    searchable :if => :published do
        integer :id

        boolean :published

        text :status

        text :created_by do
            created_by if self.created_by.present?
        end

        text :modified_by do
            modified_by if self.modified_by.present?
        end

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

        #text :place_published do
        #    place_published if self.place_published.present?
        #end

        #text :place_published_faceting, :as => 'place_published_facet'

        #text :publisher do
        #    publisher if self.publisher.present?
        #end

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

        #text :worldcat_url do
        #    worldcat_url if self.worldcat_url.present?
        #end

        #text :publisher_url do
        #    publisher_url if self.publisher_url.present?
        #end

        #text :leuven_url do
        #    leuven_url if self.leuven_url.present?
        #end

        text :multimedia_dimensions do
            multimedia_dimensions if self.multimedia_dimensions.present?
        end

        #text :multimedia_series do
        #    multimedia_series if self.multimedia_series.present?
        #end

        text :multimedia_type do
            multimedia_type if self.multimedia_type.present?
        end

        #text :multimedia_url do
        #    multimedia_url if self.multimedia_url.present?
        #end

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

        #text :event_url do
        #    event_url if self.event_url.present?
        #end

        #text :dissertation_university do
        #    dissertation_university if self.dissertation_university.present?
        #end

        #text :dissertation_university do
        #    dissertation_university if self.dissertation_university.present?
        #end

        text :dissertation_thesis_type do
            dissertation_thesis_type if self.dissertation_thesis_type.present?
        end

        #text :dissertation_university_url do
        #    dissertation_university_url if self.dissertation_university_url.present?
        #end

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
            authors.map { |author| author.person.name }
        end
        text :editors do     # for associations
            editors.map { |editor| editor.person.name }
        end
        text :book_editors do     # for associations
            book_editors.map { |book_editor| book_editor.person.name }
        end
        text :author_of_reviews do     # for associations
            author_of_reviews.map { |author_of_review| author_of_review.person.name }
        end
        text :translators do     # for associations
            translators.map { |translator| translator.person.name }
        end
        text :performers do     # for associations
            performers.map { |performer| performer.person.name }
        end
        text :translated_authors do     # for associations
            translated_authors.map { |translated_author| translated_author.person.name }
        end

        # special facet containing only authors, editors, translators
        text :authors_faceting, :as => 'authors_facet'

        # special facet containing all people types
        text :people_faceting, :as => 'people_facet'

        text :worldcat_urls do     # for associations
            worldcat_urls.map { |worldcat_url| worldcat_url.link }
        end
        text :publisher_urls do     # for associations
            publisher_urls.map { |publisher_url| publisher_url.link }
        end
        text :leuven_urls do     # for associations
            leuven_urls.map { |leuven_url| leuven_url.link }
        end
        text :multimedia_urls do     # for associations
            multimedia_urls.map { |multimedia_url| multimedia_url.link }
        end
        text :event_urls do     # for associations
            event_urls.map { |event_url| event_url.link }
        end
        text :dissertation_university_urls do     # for associations
            dissertation_university_urls.map { |dissertation_university_url| dissertation_university_url.link }
        end

        text :languages do     # for associations
            languages.map { |language| language.name }
        end
        text :languages_faceting, :as => 'languages_facet'

        text :publishers do     # for associations
            publishers.map { |publisher| publisher.name }
        end

        text :publish_places do     # for associations
            publish_places.map { |publish_place| publish_place.name }
        end
        text :publish_places_faceting, :as => 'publish_places_facet'

        text :dissertation_universities do     # for associations
            dissertation_universities.map { |dissertation_university| dissertation_university.name }
        end

        text :series_multimedium do     # for associations
            series_multimedium.map { |series_multimedia| series_multimedia.name }
        end

        text :tags do     # for associations
            tags.map { |tag| tag.name }
        end

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

        text :jesuits do     # for associations
            entities.map { |entity| entity.name }
        end
        text :jesuits_faceting, :as => 'jesuits_facet'

        text :centuries do     # for associations
            periods.map { |period| period.name }
        end
        text :centuries_faceting, :as => 'centuries_facet'

        integer :years_published, :multiple => true, :trie => true do
            pub_years = year_published.split(/\D/)
            pub_years = pub_years.map {|pub_year| pub_year.to_i}
            if pub_years.count < 2
                pub_years
            else
                start_year = pub_years[0]
                end_year = 2000 + pub_years[1]
                (start_year..end_year).to_a
            end
        end

        time :created_at
        time :updated_at
    end

    rails_admin do 
        object_label_method { :display_title }
    end

    # public method called from associated models to initiate a Solr reindex of this Bib record
    def reindex_me
        #puts "Bibliography ##{self.id} is reindexed\n\n"
        Sunspot.index! [self]
    end

    # Define form hints here
    PERSON_FIELD_HINT = 'Last name, First name'.freeze
    URL_FIELD_HINT = 'URL must start with http:// or https://'.freeze
    STATUS_FIELD_HINT = "Only 'published' records will be made public".freeze

    # Define static lists/values here
    COMMENT_TYPES = ['Note', 'Research note', 'Note to editor'].freeze
    STATUS_LIST = ['submitted', 'reviewed', 'pending', 'published'].freeze
    DEFAULT_STATUS = 'submitted'.freeze
    PUBLISHED_STATUS = 'published'.freeze

    # Define static strings
    ADD_BUTTON = '<i class="fas fa-plus" title="Add another field" aria-hidden></i> '.html_safe.freeze

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

        def publish_places_faceting
            publish_places.map { |publish_place| publish_place.name }
        end

        def languages_faceting
            languages.map { |language| language.name }
        end

        def centuries_faceting
            self.periods.map { |period| period.name }
        end

        def subjects_faceting
            self.subjects.map { |subject| subject.name }
        end

        def locations_faceting
            self.locations.map { |location| location.name }
        end

        def jesuits_faceting
            self.entities.map { |entity| entity.name }
        end

        def comments_rejectable?(comment)
            comment['body'].blank?
        end

        # we only want authors, editors and translators terms for this facet
        def authors_faceting
            authors = self.authors.map { |author| author.person.name }
            editors = self.editors.map { |editor| editor.person.name }
            translators = self.translators.map { |translator| translator.person.name }

            # merge all the arrays into authors_facet
            authors_facet = authors + editors + translators
        end

        # we want all people terms for people_facet
        def people_faceting
            authors = self.authors.map { |author| author.person.name }
            editors = self.editors.map { |editor| editor.person.name }
            translators = self.translators.map { |translator| translator.person.name }
            book_editors = self.book_editors.map { |book_editor| book_editor.person.name }
            author_of_reviews = self.author_of_reviews.map { |author_of_review| author_of_review.person.name }
            performers = self.performers.map { |performer| performer.person.name }
            translated_authors = self.translated_authors.map { |translated_author| translated_author.person.name }

            # merge all the arrays into people_facet
            people_facet = authors + editors + translators + book_editors + author_of_reviews + performers + translated_authors
        end
end