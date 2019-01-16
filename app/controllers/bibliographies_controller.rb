class BibliographiesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_bib, only: [:show, :edit, :update, :destroy]
    #after_action :generate_record_status_list, only: [:new, :edit, :update, :form_partial]
    before_action :get_current_user

    layout 'bibliography'

    NO_VALUE_FOUND = "n/a"
    
    def index
        authorize! :read, Bibliography, :message => "Unable to load this page."

        @bibs_grid = initialize_grid(Bibliography, 
            order:           'bibliographies.created_at',
            order_direction: 'desc'
        )

        @sort_name = params[:sort]
        if params[:sort] == "author"
            @sorted = :display_author
        elsif params[:sort] == "title"
            @sorted = :display_title 
        elsif params[:sort] == "format"
            @sorted = :reference_type 
        elsif params[:sort] == "earliest"
            @sorted = 'created_at ASC' 
            @sort_name = 'Earliest Created'
        elsif params[:sort] == "recent"
            @sorted = 'created_at DESC' 
            @sort_name = 'Recently created'
        else
            @sorted = 'id'
        end

        @bibs = Bibliography.order(@sorted).page(params[:page])
    end

    def show
    end

    def new
        @bib = Bibliography.new
        @bib.comments.build
        #@bib.languages.build
        @bib.reviewed_components.build
        @bib.publishers.build
        @bib.publish_places.build
        @bib.dissertation_universities.build
        @bib.series_multimedium.build
        @bib.tags.build
        #@bib.subject_suggestions.build
        #@bib.location_suggestions.build
        #@bib.entity_suggestions.build
        #@bib.period_suggestions.build
        #@bib.journal_suggestions.build
        @bib.isbns.build
        @bib.issns.build
        @bib.dois.build
        @bib.authors.build
        @bib.editors.build
        @bib.translators.build
        @bib.translated_authors.build
        @bib.book_editors.build
        @bib.author_of_reviews.build
        @bib.performers.build
        @bib.bibliography_subjects.build
        @bib.bibliography_periods.build
        @bib.bibliography_locations.build
        @bib.bibliography_entities.build
        @bib.bibliography_languages.build
        @bib.bibliography_journals.build
        @bib.worldcat_urls.build
        @bib.publisher_urls.build
        @bib.leuven_urls.build
        @bib.multimedia_urls.build
        @bib.event_urls.build
        @bib.dissertation_university_urls.build

        @reference_type = nil
        generate_record_status_list
    end

    def edit
        if !@bib.nil?
            if @bib.comments.count == 0
                @bib.comments.build
            end

            if @bib.languages.count == 0
                @bib.languages.build
            end

            if @bib.reviewed_components.count == 0
                @bib.reviewed_components.build
            end

            if @bib.publishers.count == 0
                @bib.publishers.build
            end

            if @bib.publish_places.count == 0
                @bib.publish_places.build
            end

            if @bib.dissertation_universities.count == 0
                @bib.dissertation_universities.build
            end

            if @bib.series_multimedium.count == 0
                @bib.series_multimedium.build
            end

            if @bib.tags.count == 0
                @bib.tags.build
            end

            if @bib.subject_suggestions == 0
                @bib.subject_suggestions.build
            end

            if @bib.location_suggestions == 0
                @bib.location_suggestions.build
            end

            if @bib.entity_suggestions == 0
                @bib.entity_suggestions.build
            end

            if @bib.period_suggestions == 0
                @bib.period_suggestions.build
            end

            if @bib.language_suggestions == 0
                @bib.language_suggestions.build
            end

            if @bib.person_suggestions == 0
                @bib.person_suggestions.build
            end

            if @bib.journal_suggestions == 0
                @bib.journal_suggestions.build
            end

            if @bib.isbns.count == 0
                @bib.isbns.build
            end

            if @bib.issns.count == 0
                @bib.issns.build
            end

            if @bib.dois.count == 0
                @bib.dois.build
            end

            if @bib.authors.count == 0
                @bib.authors.build
            end

            if @bib.editors.count == 0
                @bib.editors.build
            end

            if @bib.translators.count == 0
                @bib.translators.build
            end

            if @bib.translated_authors.count == 0
                @bib.translated_authors.build
            end

            if @bib.book_editors.count == 0
                @bib.book_editors.build
            end

            if @bib.author_of_reviews.count == 0
                @bib.author_of_reviews.build
            end

            if @bib.performers.count == 0
                @bib.performers.build
            end

            if @bib.bibliography_subjects.count == 0
                @bib.bibliography_subjects.build
            end

            if @bib.bibliography_periods.count == 0
                @bib.bibliography_periods.build
            end

            if @bib.bibliography_locations.count == 0
                @bib.bibliography_locations.build
            end

            if @bib.bibliography_entities.count == 0
                @bib.bibliography_entities.build
            end

            if @bib.bibliography_languages.count == 0
                @bib.bibliography_languages.build
            end

            if @bib.bibliography_journals.count == 0
                @bib.bibliography_journals.build
            end

            if @bib.worldcat_urls.count == 0
                @bib.worldcat_urls.build
            end

            if @bib.publisher_urls.count == 0
                @bib.publisher_urls.build
            end

            if @bib.leuven_urls.count == 0
                @bib.leuven_urls.build
            end

            if @bib.multimedia_urls.count == 0
                @bib.multimedia_urls.build
            end

            if @bib.event_urls.count == 0
                @bib.event_urls.build
            end

            if @bib.dissertation_university_urls.count == 0
                @bib.dissertation_university_urls.build
            end

            @reference_type = @bib.reference_type
            generate_record_status_list
        end
    end

    def create
        @bib = Bibliography.new(bib_params)

        # set the created_by value to be the current_user
        @bib.created_by = current_user

        check_authorization(:create, "Unable to create this Bibliography record.")
        #authorize! :create, Bibliography, :message => "Unable to create this Bibliography record."

        # check that this record has a status assigned
        check_record_status

        # set the display_* fields for Blacklight views
        set_display_fields

        # loop through each associated comment object and check if it has changed
        # if it has changed, be sure to update the comment.commenter value
        @bib.comments.each do |comment|
            if comment.changed?
                '''
                puts "###### found a new comment ######"
                puts comment.body
                puts comment.comment_type
                puts comment.make_public
                puts comment.commenter
                puts "#################################"
                '''
                comment.commenter = current_user
            end
        end

        if @bib.save
            respond_to do |format|
                format.html { redirect_to @bib, notice: 'Bibliography was successfully created.' }
                format.json { render :show, status: :created, location: @bib }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @bib.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        check_authorization(:update, "Unable to update this Bibliography record.")

        # copy over bib_params into @bib object so we can alter it
        @bib.attributes = bib_params

        # check that this record has a status assigned
        check_record_status

        # set the display_* fields for Blacklight views
        set_display_fields

        @bib.modified_by = current_user

        generate_record_status_list

        # loop through each associated comment object and check if it has changed
        # if it has changed, be sure to update the comment.commenter value
        @bib.comments.each do |comment|
            if comment.changed?
                '''
                puts "###### found a new comment ######"
                puts comment.body
                puts comment.comment_type
                puts comment.make_public
                puts comment.commenter
                puts "#################################"
                '''
                if comment.commenter.nil?
                    comment.commenter = current_user
                end
            end
        end

        if @bib.save!(bib_params)
            respond_to do |format|
                format.html { redirect_to @bib, notice: 'Bibliography was successfully updated.' }
                format.json { render :show, status: :ok, location: @bib }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @bib.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        check_authorization(:destroy, "Unable to destroy this Bibliography record.")

        @bib.destroy
        respond_to do |format|
            format.html { redirect_to bibliographies_path, notice: 'Bibliography was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def form_partial
        if params[:id] == "new"
            new
        else
            set_bib
            edit
        end
        
        generate_record_status_list

        @form_partial = params[:reference_type]
        respond_to do |format|
            format.js
        end
    end

    def mine
        @bibs_grid = initialize_grid(Bibliography, 
            conditions: {created_by: current_user.email},
            order:           'bibliographies.created_at',
            order_direction: 'desc'
        )
    end

    # TODO find better way of checking for suggestions
    def suggestions
        authorize! :manage, 'Suggestions', :message => "Unable to load this page."

        suggestion_tables = [
            :location_suggestions, 
            :person_suggestions, 
            :subject_suggestions, 
            :entity_suggestions, 
            :period_suggestions, 
            :language_suggestions,
            :journal_suggestions
        ]

        where_clause = []
        suggestion_tables.each do |t|
            where_clause << "#{t.to_s}.name IS NOT NULL"
        end

        @bibs_grid = initialize_grid(Bibliography, 
            conditions: [where_clause.join(" OR ")],
            include: suggestion_tables,
            order:           'bibliographies.created_at',
            order_direction: 'desc'
        )
    end

    private
        # this method checks that one of two conditions is true:
        #   the current user matches the account used to create this record,
        #   or the proper cancan ability is set for this action
        def check_authorization(action, msg)
            message = msg || "Unable to access this Bibliography record."

            if @bib.created_by.to_s == current_user.to_s
                # the current user matches the account used to create this record
            else
                # the current user doesn't match the account used to create this record 
                # so check if the current user can perform the give action on this record
                case action
                when :read
                    authorize! :read, Bibliography, :message => msg
                when :create
                    authorize! :create, Bibliography, :message => msg
                when :update
                    authorize! :update, Bibliography, :message => msg
                when :destroy
                    authorize! :destroy, Bibliography, :message => msg
                end
            end
        end

        # set the record status if it is not already set.
        # if the status value is blank then assign to Bibliography::DEFAULT_STATUS
        # TODO make sure a contributor can't somehow force their record to be 'published'
        def check_record_status
            if @bib.status.blank?
                @bib.status = Bibliography::DEFAULT_STATUS
            end

            # also make sure that if the record has a status of Bibliography::PUBLISHED_STATUS 
            # that we also set the @bib.published field to be 'true'. 
            # otherwise, set @bib.published field to 'false'
            # TODO remove/hide the @bib.published field as it duplicates the status field
            if @bib.status == Bibliography::PUBLISHED_STATUS
                @bib.published = true
            else
                @bib.published = false
            end
        end

        def set_bib
            begin
                @bib = Bibliography.find(params[:id])
                check_authorization(:read, "Unable to read this Bibliography record.")
            rescue ActiveRecord::RecordNotFound => e
                @bib = nil
            end
        end

        def get_current_user
            @this_user = current_user
        end

        def generate_record_status_list
            @status_list = []
            if can? :manage, 'Publish'
                @status_list = Bibliography::STATUS_LIST
            elsif @bib.status == 'published'
                @status_list = Bibliography::STATUS_LIST
            else
                @status_list = Bibliography::STATUS_LIST - ['published']
            end

            puts "\n\nstatus list: #{@status_list}\n\n"

            @status_list
        end

        def bib_params
            params.require(:bibliography).permit(:reference_type, :year_published, :title, :title_secondary, 
                :volume, :number_of_volumes, :volume_number, :number_of_pages, :edition, :date, :chapter_number, :book_title,
                :reprint_edition, :multimedia_dimensions, :abstract, :translated_title,
                :issue, :page_range, :epub_date, :title_of_review, :chapter_title, :paper_title,
                :display_title, :display_year, :display_author,
                :dissertation_thesis_type,
                :event_title, :event_location, :event_institution, :event_date, :event_panel_title, 
                :multimedia_type, :published, :status,
                comments_attributes: [:id, :commenter, :body, :comment_type, :make_public, :_destroy],
                #languages_attributes: [:id, :name, :_destroy],
                publishers_attributes: [:id, :name, :_destroy],
                publish_places_attributes: [:id, :name, :_destroy],
                dissertation_universities_attributes: [:id, :name, :_destroy],
                series_multimedium_attributes: [:id, :name, :_destroy],
                tags_attributes: [:id, :name, :_destroy],
                subject_suggestions_attributes: [:id, :name, :note, :_destroy],
                location_suggestions_attributes: [:id, :name, :note, :_destroy],
                entity_suggestions_attributes: [:id, :name, :note, :_destroy],
                period_suggestions_attributes: [:id, :name, :note, :_destroy],
                language_suggestions_attributes: [:id, :name, :note, :_destroy],
                person_suggestions_attributes: [:id, :name, :note, :field_name, :_destroy],
                journal_suggestions_attributes: [:id, :name, :note, :_destroy],
                reviewed_components_attributes: [:id, :reviewed_author, :reviewed_editor, :reviewed_translator, :reviewed_title, :_destroy],
                bibliography_subjects_attributes: [:id, :subject_id, :_destroy],
                bibliography_periods_attributes: [:id, :period_id, :_destroy],
                bibliography_locations_attributes: [:id, :location_id, :_destroy],
                bibliography_entities_attributes: [:id, :entity_id, :_destroy],
                bibliography_languages_attributes: [:id, :language_id, :_destroy],
                bibliography_journals_attributes: [:id, :journal_id, :_destroy],
                isbns_attributes: [:id, :value, :_destroy],
                issns_attributes: [:id, :value, :_destroy],
                dois_attributes: [:id, :value, :_destroy],
                worldcat_urls_attributes: [:id, :link, :_destroy],
                publisher_urls_attributes: [:id, :link, :_destroy],
                leuven_urls_attributes: [:id, :link, :_destroy],
                multimedia_urls_attributes: [:id, :link, :_destroy],
                event_urls_attributes: [:id, :link, :_destroy],
                dissertation_university_urls_attributes: [:id, :link, :_destroy],
                authors_attributes: [:id, :person_id, :_destroy],
                editors_attributes: [:id, :person_id, :_destroy],
                translators_attributes: [:id, :person_id, :_destroy],
                translated_authors_attributes: [:id, :person_id, :_destroy],
                book_editors_attributes: [:id, :person_id, :_destroy],
                author_of_reviews_attributes: [:id, :person_id, :_destroy],
                performers_attributes: [:id, :person_id, :_destroy],
            )
        end

        # depending on the reference_type, select the fields to represent the 
        # display_title and display_author fields used in the discovery layer
        def set_display_fields
            if @bib.reference_type.downcase == "book"
                if @bib.title.present?
                    @bib.display_title = @bib.title
                else
                    @bib.display_title = NO_VALUE_FOUND
                end
                
                if @bib.authors.present?
                    out = []
                    @bib.authors.each do |author|
                        out << author.person.name
                    end
                    @bib.display_author = out.join('|')
                elsif @bib.editors.present?
                    out = []
                    @bib.editors.each do |editor|
                        out << editor.person.name
                    end
                    @bib.display_author = out.join('|')
                else
                    @bib.display_author = NO_VALUE_FOUND
                end
            elsif @bib.reference_type.downcase == "book chapter"
                if @bib.chapter_title.present?
                    @bib.display_title = @bib.chapter_title
                else
                    @bib.display_title = NO_VALUE_FOUND
                end
                
                if @bib.authors.present?
                    out = []
                    @bib.authors.each do |author|
                        out << author.person.name
                    end
                    @bib.display_author = out.join('|')
                else
                    @bib.display_author = NO_VALUE_FOUND
                end
            elsif @bib.reference_type.downcase == "book review"
                if @bib.title_of_review.present?
                    @bib.display_title = @bib.title_of_review
                else
                    @bib.display_title = NO_VALUE_FOUND
                end

                if @bib.author_of_reviews.present?
                    out = []
                    @bib.author_of_reviews.each do |author|
                        out << author.person.name
                    end
                    @bib.display_author = out.join('|')
                else
                    @bib.display_author = NO_VALUE_FOUND
                end
            elsif @bib.reference_type.downcase == "conference paper"
                if @bib.paper_title.present?
                    @bib.display_title = @bib.paper_title
                else
                    @bib.display_title = NO_VALUE_FOUND
                end

                if @bib.author_of_reviews.present?
                    out = []
                    @bib.author_of_reviews.each do |author|
                        out << author.person.name
                    end
                    @bib.display_author = out.join('|')
                else
                    @bib.display_author = NO_VALUE_FOUND
                end
            else # dissertation, journal article, multimedia
                if @bib.title.present?
                    @bib.display_title = @bib.title
                else
                    @bib.display_title = NO_VALUE_FOUND
                end

                if @bib.authors.present?
                    out = []
                    @bib.authors.each do |author|
                        out << author.person.name
                    end
                    @bib.display_author = out.join('|')
                else
                    @bib.display_author = NO_VALUE_FOUND
                end
            end
        end
end
