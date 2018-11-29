class BibliographiesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_bib, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        @bibs = Bibliography.all
    end

    def show
    end

    def new
        @bib = Bibliography.new
        @bib.comments.build
        @bib.languages.build
        @bib.isbns.build
        @bib.issns.build
        @bib.dois.build
        @bib.authors.build
        @bib.editors.build
        @bib.book_editors.build
        @bib.author_of_reviews.build
        @bib.reviewed_authors.build
        @bib.translators.build
        @bib.performers.build
        @bib.translated_authors.build

        @reference_type = nil
    end

    def edit
        @bib.comments.build
        @bib.languages.build
        @bib.isbns.build
        @bib.issns.build
        @bib.dois.build
        @bib.authors.build
        @bib.editors.build
        @bib.book_editors.build
        @bib.author_of_reviews.build
        @bib.reviewed_authors.build
        @bib.translators.build
        @bib.performers.build
        @bib.translated_authors.build

        @reference_type = @bib.reference_type
    end

    def create
        @bib = Bibliography.new(bib_params)

        # set the display_ fields for Blacklight views
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
        # copy over bib_params into @bib object so we can alter it
        @bib.attributes = bib_params

        # set the display_ fields for Blacklight views
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
            rescue ActiveRecord::RecordNotFound => e
                @bib = nil
            end
        end

        def bib_params
            params.require(:bibliography).permit(:reference_type, :year_published, :title, :title_secondary, :place_published, :publisher, 
                :volume, :number_of_volumes, :volume_number, :number_of_pages, :edition, :date, :chapter_number, :book_title,
                :reprint_edition, :worldcat_url, :publisher_url, :leuven_url, :multimedia_dimensions, :abstract, :translated_title, :reviewed_title,
                :journal_title, :issue, :page_range, :epub_date, :title_of_review, :chapter_title,
                :display_title, :display_year, :display_author,
                :dissertation_university, :dissertation_thesis_type, :dissertation_university_url,
                :event_title, :event_location, :event_institution, :event_date, :event_panel_title, :event_url, 
                :multimedia_series, :multimedia_type, :multimedia_url,
                comments_attributes: [:id, :commenter, :body, :comment_type, :make_public, :_destroy],
                languages_attributes: [:id, :name, :_destroy],
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
                reviewed_authors_attributes: [:id, :display_name, :_destroy],
                translators_attributes: [:id, :display_name, :_destroy],
                performers_attributes: [:id, :display_name, :_destroy],
                translated_authors_attributes: [:id, :display_name, :_destroy],
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
                if @bib.chapter_title.present?
                    @bib.display_title = @bib.title_of_review
                end
                if @bib.authors.present?
                    @bib.display_author = @bib.author_of_reviews.map { |author| author.display_name }.to_sentence
                end
            else
                if @bib.chapter_title.present?
                    @bib.display_title = @bib.title
                end
                if @bib.authors.present?
                    @bib.display_author = @bib.authors.map { |author| author.display_name }.to_sentence
                end
            end
        end
end
