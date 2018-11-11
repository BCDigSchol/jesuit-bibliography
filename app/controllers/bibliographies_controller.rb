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
        @bib.isbns.build
        @bib.issns.build
        @bib.dois.build
    end

    def edit
        @bib.comments.build
        @bib.isbns.build
        @bib.issns.build
        @bib.dois.build
    end

    def create
        @bib = Bibliography.new(bib_params)

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
                :volume, :number_of_volumes, :pages, :section, :title_tertiary, :edition, :date, :type_of_work,
                :reprint_edition, :abstract, :title_translated, :language,
                comments_attributes: [:id, :commenter, :body, :comment_type, :make_public, :_destroy],
                bibliography_subjects_attributes: [:id, :subject_id, :_destroy],
                bibliography_periods_attributes: [:id, :period_id, :_destroy],
                bibliography_locations_attributes: [:id, :location_id, :_destroy],
                bibliography_entities_attributes: [:id, :entity_id, :_destroy],
                isbns_attributes: [:id, :value, :_destroy],
                issns_attributes: [:id, :value, :_destroy],
                dois_attributes: [:id, :value, :_destroy],
            )
        end
end
