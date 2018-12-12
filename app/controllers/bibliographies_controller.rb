class BibliographiesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_bib, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'
    
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
        @bib.languages.build
        @bib.reviewed_components.build
        @bib.isbns.build
        @bib.issns.build
        @bib.dois.build
        @bib.authors.build
        @bib.editors.build
        @bib.book_editors.build
        @bib.author_of_reviews.build
        @bib.translators.build
        @bib.performers.build
        @bib.translated_authors.build
        @bib.bibliography_subjects.build
        @bib.bibliography_periods.build
        @bib.bibliography_locations.build
        @bib.bibliography_entities.build
        @bib.worldcat_urls.build
        @bib.publisher_urls.build
        @bib.leuven_urls.build
        @bib.multimedia_urls.build
        @bib.event_urls.build
        @bib.dissertation_university_urls.build

        @reference_type = nil
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

            if @bib.book_editors.count == 0
                @bib.book_editors.build
            end

            if @bib.author_of_reviews.count == 0
                @bib.author_of_reviews.build
            end

            if @bib.translators.count == 0
                @bib.translators.build
            end

            if @bib.performers.count == 0
                @bib.performers.build
            end

            if @bib.translated_authors.count == 0
                @bib.translated_authors.build
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
        end
    end

    def create
        @bib = Bibliography.new(bib_params)

        authorize! :create, @bib, :message => "Unable to create this Bibliography record."

        # set the display_* fields for Blacklight views
        set_display_fields

        @bib.created_by = current_user

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
        authorize! :update, @bib, :message => "Unable to update this Bibliography record."

        # copy over bib_params into @bib object so we can alter it
        @bib.attributes = bib_params

        # set the display_* fields for Blacklight views
        set_display_fields

        @bib.modified_by = current_user

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
        authorize! :destroy, @bib, :message => "Unable to destroy this Bibliography record."

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

        @form_partial = params[:reference_type]
        respond_to do |format|
            format.js
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_bib
            begin
                @bib = Bibliography.find(params[:id])
                authorize! :read, @bib, :message => "Unable to read this Bibliography record."
            rescue ActiveRecord::RecordNotFound => e
                @bib = nil
            end
        end

        def bib_params
            params.require(:bibliography).permit(:reference_type, :year_published, :title, :title_secondary, :place_published, :publisher, 
                :volume, :number_of_volumes, :volume_number, :number_of_pages, :edition, :date, :chapter_number, :book_title,
                :reprint_edition, :multimedia_dimensions, :abstract, :translated_title,
                :journal_title, :issue, :page_range, :epub_date, :title_of_review, :chapter_title, :paper_title,
                :display_title, :display_year, :display_author,
                :dissertation_university, :dissertation_thesis_type,
                :event_title, :event_location, :event_institution, :event_date, :event_panel_title, 
                :multimedia_series, :multimedia_type, :published,
                comments_attributes: [:id, :commenter, :body, :comment_type, :make_public, :_destroy],
                languages_attributes: [:id, :name, :_destroy],
                reviewed_components_attributes: [:id, :reviewed_author, :reviewed_title, :_destroy],
                bibliography_subjects_attributes: [:id, :subject_id, :_destroy],
                bibliography_periods_attributes: [:id, :period_id, :_destroy],
                bibliography_locations_attributes: [:id, :location_id, :_destroy],
                bibliography_entities_attributes: [:id, :entity_id, :_destroy],
                isbns_attributes: [:id, :value, :_destroy],
                issns_attributes: [:id, :value, :_destroy],
                dois_attributes: [:id, :value, :_destroy],
                authors_attributes: [:id, :display_name, :_destroy],
                editors_attributes: [:id, :display_name, :_destroy],
                book_editors_attributes: [:id, :display_name, :_destroy],
                author_of_reviews_attributes: [:id, :display_name, :_destroy],
                translators_attributes: [:id, :display_name, :_destroy],
                performers_attributes: [:id, :display_name, :_destroy],
                translated_authors_attributes: [:id, :display_name, :_destroy],
                worldcat_urls_attributes: [:id, :link, :_destroy],
                publisher_urls_attributes: [:id, :link, :_destroy],
                leuven_urls_attributes: [:id, :link, :_destroy],
                multimedia_urls_attributes: [:id, :link, :_destroy],
                event_urls_attributes: [:id, :link, :_destroy],
                dissertation_university_urls_attributes: [:id, :link, :_destroy],
            )
        end

        def set_display_fields
            if @bib.reference_type.downcase == "book chapter"
                if @bib.chapter_title.present?
                    @bib.display_title = @bib.chapter_title
                end
                if @bib.authors.present?
                    @bib.display_author = @bib.authors.map { |author| author.display_name }.to_sentence
                end
            elsif @bib.reference_type.downcase == "book review"
                if @bib.title_of_review.present?
                    @bib.display_title = @bib.title_of_review
                end
                if @bib.authors.present?
                    @bib.display_author = @bib.author_of_reviews.map { |author| author.display_name }.to_sentence
                end
            elsif @bib.reference_type.downcase == "conference paper"
                if @bib.paper_title.present?
                    @bib.display_title = @bib.paper_title
                end
                if @bib.authors.present?
                    @bib.display_author = @bib.author_of_reviews.map { |author| author.display_name }.to_sentence
                end
            else # book, dissertation, journal article, multimedia
                if @bib.title.present?
                    @bib.display_title = @bib.title
                end
                if @bib.authors.present?
                    @bib.display_author = @bib.authors.map { |author| author.display_name }.to_sentence
                end
            end
        end
end
