class Bibliography < ApplicationRecord
    include CitationsGenerator
    include BibliographyIndexer
    include BibliographyAdmin

    has_one :featuredrecord

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
    has_many :journal_suggestions, inverse_of: :bibliography, dependent: :destroy
    has_many :thesis_type_suggestions, inverse_of: :bibliography, dependent: :destroy

    has_many :authors, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :authors

    has_many :editors, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :editors

    has_many :translators, inverse_of: :bibliography, dependent: :destroy
    has_many :people, through: :translators

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

    # many-to-many relationship through bibliography_journals
    has_many :bibliography_journals, inverse_of: :bibliography, dependent: :destroy
    has_many :journals, through: :bibliography_journals

    # many-to-many relationship through bibliography_thesis_types
    has_many :bibliography_thesis_types, inverse_of: :bibliography, dependent: :destroy
    has_many :thesis_types, through: :bibliography_thesis_types

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
    accepts_nested_attributes_for :journal_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :thesis_type_suggestions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :bibliography_subjects, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_periods, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_locations, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_entities, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_languages, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_journals, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_thesis_types, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :isbns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :issns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :dois, reject_if: :all_blank, allow_destroy: true

    accepts_nested_attributes_for :authors, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :editors, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :translators, reject_if: :all_blank, allow_destroy: true
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
    validates :year_published, presence: true

    #
    # validate various title fields depending on reference_type
    #

    validates :title, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book', 'journal article', 'dissertation', 'multimedia'] }

    validates :chapter_title, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book chapter'] }

    validates :title_of_review, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book review'] }

    validates :paper_title, presence: true,
        if: Proc.new { reference_type_is_one_of? ['conference paper'] }

    validates :publish_places, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book', 'book chapter', 'dissertation'] }

    validates :publishers, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book', 'book chapter'] }

    validates :book_title, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book chapter'] }

    validates :event_location, presence: true,
        if: Proc.new { reference_type_is_one_of? ['conference paper'] }

    validates :dissertation_universities, presence: true,
        if: Proc.new { reference_type_is_one_of? ['dissertation'] }

    validates :multimedia_type, presence: true,
        if: Proc.new { reference_type_is_one_of? ['multimedia'] }

    validates :multimedia_urls, presence: true,
        if: Proc.new { reference_type_is_one_of? ['multimedia'] }

    validates :reviewed_components, presence: true,
        if: Proc.new { reference_type_is_one_of? ['book review'] }

    validate :url_has_correct_format

    # Define form hints here
    PERSON_FIELD_HINT = 'Last name, First name'.freeze
    URL_FIELD_HINT = 'URL must start with http:// or https://'.freeze
    STATUS_FIELD_HINT = "Only 'published' records will be made public".freeze
    DISPLAY_NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
    TERM_FIELD_HINT = 'This field is strongly recommended'.freeze
    AUTHOR_OF_REVIEW_HINT = 'Please use \'N/A\' for anonymous reviews'.freeze
    EVENT_INSTITUTION_HINT = 'e.g. Renaissance Society of America, Universidad de Deusto'.freeze
    LINK_TO_BOOK_RECORD_HINT = 'Search for the Book record you want to link. Make sure the linked Book record status is \'Published\''.freeze
    BOOK_AUTHOR_EDITOR_HINT = 'Either Author or Editor is required'.freeze
    DOI_HINT = 'Only enter the numeric ID for each DOI (e.g. 10.1177/239693930903300206)'.freeze
    YEAR_PUBLISHED_HINT = 'Only records for items since 2000 will be published. Publication with a range of years should take the form 2002-08'.freeze
    ISBN_HINT = 'Only enter the numeric ID for each ISBN with no dashes (e.g. 1234567890123)'.freeze
    
    # Define static lists/values here
    DOCUMENT_TYPES_LIST = ['book', 'book_chapter', 'book_review', 'journal_article', 'dissertation', 'conference_paper', 'multimedia'].freeze
    COMMENT_TYPES = ['Note', 'Research note', 'Note to editor'].freeze
    STATUS_LIST = ['submitted', 'reviewed', 'pending', 'published'].freeze
    DEFAULT_STATUS = 'submitted'.freeze
    PUBLISHED_STATUS = 'published'.freeze

    # Define static strings
    ADD_BUTTON = '<i class="fas fa-plus" title="Add another field" aria-hidden></i> '.html_safe.freeze
    REQUIRED_FLAG = ' <abbr title="required">*</abbr>'.html_safe.freeze
    NO_DISPLAY_TITLE = '<em>No Title</em>'.html_safe.freeze
    NO_DISPLAY_AUTHOR = '<em>No Author</em>'.html_safe.freeze

    def generate_citations
        generate_all_citations
    end

    # depending on the reference_type, select the fields to represent the
    # display_title and display_author fields used in the discovery layer
    NO_VALUE_FOUND = "n/a"

    def set_display_fields
        if self.reference_type.downcase == "book"
            if self.title.present?
                unless self.display_title.present?
                    self.display_title = self.title
                end
            else
                self.display_title = NO_VALUE_FOUND
            end

            if self.authors.present?
                out = []
                self.authors.each do |author|
                    out << author.person.name
                end
                self.display_author = out.join('|')
            elsif self.editors.present?
                out = []
                self.editors.each do |editor|
                    out << editor.person.name
                end
                self.display_author = out.join('|')
            else
                self.display_author = NO_VALUE_FOUND
            end
        elsif self.reference_type.downcase == "book chapter"
            if self.chapter_title.present?
                unless self.display_title.present?
                    self.display_title = self.chapter_title
                end
            else
                self.display_title = NO_VALUE_FOUND
            end

            if self.authors.present?
                out = []
                self.authors.each do |author|
                    out << author.person.name
                end
                self.display_author = out.join('|')
            else
                self.display_author = NO_VALUE_FOUND
            end
        elsif self.reference_type.downcase == "book review"
            if self.title_of_review.present?
                unless self.display_title.present?
                    self.display_title = self.title_of_review
                end
            else
                self.display_title = NO_VALUE_FOUND
            end

            if self.author_of_reviews.present?
                out = []
                self.author_of_reviews.each do |author|
                    out << author.person.name
                end
                self.display_author = out.join('|')
            else
                self.display_author = NO_VALUE_FOUND
            end
        elsif self.reference_type.downcase == "conference paper"
            if self.paper_title.present?
                unless self.display_title.present?
                    self.display_title = self.paper_title
                end
            else
                self.display_title = NO_VALUE_FOUND
            end

            if self.authors.present?
                out = []
                self.authors.each do |author|
                    out << author.person.name
                end
                self.display_author = out.join('|')
            else
                self.display_author = NO_VALUE_FOUND
            end
        else # dissertation, journal article, multimedia
            if self.title.present?
                unless self.display_title.present?
                    self.display_title = self.title
                end
            else
                self.display_title = NO_VALUE_FOUND
            end

            if self.authors.present?
                out = []
                self.authors.each do |author|
                    out << author.person.name
                end
                self.display_author = out.join('|')
            else
                self.display_author = NO_VALUE_FOUND
            end
        end
    end

    # set the record status if it is not already set.
    # if the status value is blank then assign to DEFAULT_STATUS
    # TODO make sure a contributor can't somehow force their record to be 'published'
    def check_record_status
        if self.status.blank?
            self.status = DEFAULT_STATUS
        end

        # also make sure that if the record has a status of PUBLISHED_STATUS
        # that we also set the @bib.published field to be 'true'.
        # otherwise, set @bib.published field to 'false'
        # TODO remove/hide the @bib.published field as it duplicates the status field
        if self.status == PUBLISHED_STATUS
            self.published = true
        else
            self.published = false
        end
    end

    # update the record, display fields, and citations. 
    # this is generally called from within associated records to trigger a cleanup for reindexing purposes.
    def refresh
        self.set_display_fields
        self.generate_all_citations
    
        self.modified_by = "admin"
        self.save
    end


    def first_isbn
        first_isbn = nil
        unless isbns.empty?
            first_isbn = isbns[0].value
        end
        first_isbn
    end

    def first_issn
        first_issn = nil
        unless isbns.empty?
            first_issn = isbns[0].value
        end
        first_issn
    end

    def reviewed_author
        if reviewed_components.present?
            authors = []
            reviewed_components.each do |rc|
                if rc.reviewed_author.present?
                    authors << rc.reviewed_author
                end
            end
            if authors.empty?
                return nil
            end
            authors
        end
    end

    def reviewed_editor
        if reviewed_components.present?
            editors = []
            reviewed_components.each do |rc|
                if rc.reviewed_editor.present?
                    editors << rc.reviewed_editor
                end
            end
            if editors.empty?
                return nil
            end
            editors
        end
    end

    def reviewed_translator
        if reviewed_components.present?
            translators = []
            reviewed_components.each do |rc|
                if rc.reviewed_translator.present?
                    translators << rc.reviewed_translator
                end
            end
            if translators.empty?
                return nil
            end
            translators
        end
    end

    def reviewed_title
        if reviewed_components.present?
            titles = []
            reviewed_components.each do |rc|
                if rc.reviewed_title.present?
                    titles << rc.reviewed_title
                end
            end
            if titles.empty?
                return nil
            end
            titles
        end
    end

    # Generate a list of editors for display
    #
    # @return [String] a list of editors for display
    def display_editors
        unless self.editors.present? || self.book_editors.present?
            return nil
        end

        out = []

        self.editors.each do |editor|
            out << editor.person.name
        end

        self.book_editors.each do |editor|
            out << editor.person.name
        end

        out.join('|')
    end

    private
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

        def journals_faceting
            journals.map { |journal| journal.name }
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

            # merge all the arrays into people_facet
            people_facet = authors + editors + translators + book_editors + author_of_reviews + performers
        end

        def book_title_html
            if self.book_title.present?
                out = "<div class='rc-block'><div class='rc-item'>#{self.book_title}</div>"
                if self.book_chapter_record_ref.present?
                    out += "<div class='rc-item'><span class='rc-record-link'><a href='#{Rails.application.routes.url_helpers.solr_document_path(self.book_chapter_record_ref)}'>Go to item</a></span></div>"
                end
                out += "</div>"
                return out
            end
        end

        def book_has_author_or_editor
            if reference_type_is_one_of? ['book']
                unless authors.present? || editors.present?
                    errors.add(:authors, "or Editor must be present")
                end
            end
        end

        def reference_type_is_one_of? (types_array)
            # TODO check if types_array is an array
            if reference_type.present?
                return types_array.include? reference_type.downcase
            end
            false
        end

        def url_has_correct_format
            error_message = "must begin with http:// or https://"
            #prefix_compare_list = ['https://', 'http://']

            # worldcat_url
            if reference_type_is_one_of? ['book', 'book chapter', 'book review', 'journal article', 'dissertation', 'multimedia']
                if worldcat_urls.present?
                    worldcat_urls.each do |url|
                        errors.add(:worldcat_urls, error_message) unless url.link.downcase.start_with?('https://', 'http://')
                    end
                end
            end

            # publisher_urls
            if reference_type_is_one_of? ['book', 'book chapter', 'book review', 'journal article']
                if publisher_urls.present?
                    publisher_urls.each do |url|
                        errors.add(:publisher_urls, error_message) unless url.link.downcase.start_with?('https://', 'http://')
                    end
                end
            end

            # leuven_urls
            if reference_type_is_one_of? ['book', 'book chapter', 'book review', 'journal article', 'dissertation']
                if leuven_urls.present?
                    leuven_urls.each do |url|
                        errors.add(:leuven_urls, error_message) unless url.link.downcase.start_with?('https://', 'http://')
                    end
                end
            end

            # dissertation_university_urls
            if reference_type_is_one_of? ['dissertation']
                if dissertation_university_urls.present?
                    dissertation_university_urls.each do |url|
                        errors.add(:dissertation_university_urls, error_message) unless url.link.downcase.start_with?('https://', 'http://')
                    end
                end
            end

            # event_urls
            if reference_type_is_one_of? ['conference paper']
                if event_urls.present?
                    event_urls.each do |url|
                        errors.add(:event_urls, error_message) unless url.link.downcase.start_with?('https://', 'http://')
                    end
                end
            end

            # multimedia_urls
            if reference_type_is_one_of? ['multimedia']
                if multimedia_urls.present?
                    multimedia_urls.each do |url|
                        errors.add(:multimedia_urls, error_message) unless url.link.downcase.start_with?('https://', 'http://')
                    end
                end
            end
        end
end
