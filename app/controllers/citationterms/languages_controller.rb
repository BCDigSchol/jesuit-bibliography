class Citationterms::LanguagesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_language, only: [:show, :edit, :update, :destroy, :references]

    layout 'bibliography'

    def index
        authorize! :read, Language, :message => "Unable to load this page."

        @languages_grid = initialize_grid(Language, 
            order:           'languages.normal_name',
            order_direction: 'asc'
        )

        @languages = Language.all
    end

    def show
    end

    def new
        @language = Language.new
    end

    def edit
    end

    def create
        @language = Language.new(language_params)

        authorize! :create, @language, :message => "Unable to create this Language record."

        @language.created_by = current_user

        if @language.save
            respond_to do |format|
                format.html { redirect_to citationterms_language_path(@language), notice: 'Language was successfully created.' }
                format.json { render :show, status: :created, location: @language }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @language.errors, status: :unprocessable_language }
            end
        end
    end

    def update
        authorize! :update, @language, :message => "Unable to update this Language record."

        # copy over subject_params into period_attributes so we can alter it
        language_attributes = language_params

        # update modified_by
        language_attributes[:modified_by] = current_user

        if @language.update(language_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_language_path(@language), notice: 'Language was successfully updated.' }
                format.json { render :show, status: :ok, location: @language }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @language.errors, status: :unprocessable_language }
            end
        end
    end

    def destroy
        authorize! :destroy, @language, :message => "Unable to destroy this Language record."

        @language.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_languages_path, notice: 'Language was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def references
        @bibs_grid = initialize_grid(@language.bib_refs) unless @language.nil?
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_language
            begin
                @language = Language.find(params[:id])
                authorize! :read, @language, :message => "Unable to read this Language record."
            rescue ActiveRecord::RecordNotFound => e
                @language = nil
            end
        end

        def language_params
            params.require(:language).permit(:name)
        end
end
