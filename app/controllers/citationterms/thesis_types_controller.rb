class Citationterms::ThesisTypesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_thesistype, only: [:show, :edit, :update, :destroy, :references]

    layout 'bibliography'

    def index
        authorize! :read, ThesisType, :message => "Unable to load this page."

        @thesis_types_grid = initialize_grid(ThesisType, 
            order:           'thesis_types.normal_name',
            order_direction: 'asc'
        )

        @thesis_types = ThesisType.all
    end

    def show
    end

    def new
        authorize! :create, ThesisType, :message => "Unable to create this Thesis Type record."
        @thesis_type = ThesisType.new
    end

    def edit
        authorize! :update, ThesisType, :message => "Unable to update this Thesis Type record."
    end

    def create
        authorize! :create, ThesisType, :message => "Unable to create this Thesis Type record."

        @thesis_type = ThesisType.new(thesistype_params)

        @thesis_type.created_by = current_user

        if @thesis_type.save
            respond_to do |format|
                format.html { redirect_to citationterms_thesis_type_path(@thesis_type), notice: 'Thesis Type was successfully created.' }
                format.json { render :show, status: :created, location: @thesis_type }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @thesis_type.errors, status: :unprocessable_thesistype }
            end
        end
    end

    def update
        authorize! :update, ThesisType, :message => "Unable to update this Thesis Type record."

        # copy over thesistype_attributes intothesistype_params so we can alter it
        thesistype_attributes = thesistype_params

        # update modified_by
        thesistype_attributes[:modified_by] = current_user

        if @thesis_type.update(thesistype_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_thesis_type_path(@thesis_type), notice: 'Thesis Type was successfully updated.' }
                format.json { render :show, status: :ok, location: @thesis_type }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @thesis_type.errors, status: :unprocessable_thesistype }
            end
        end
    end

    def destroy
        authorize! :destroy, ThesisType, :message => "Unable to destroy this Thesis Type record."

        @thesis_type.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_thesis_types_path, notice: 'Thesis Type was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def references
        @bibs_grid = initialize_grid(@thesis_type.bib_refs)
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_thesistype
            authorize! :read, ThesisType, :message => "Unable to read this Thesis Type record."

            begin
                @thesis_type = ThesisType.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                @thesis_type = nil
            end
        end

        def thesistype_params
            params.require(:thesis_type).permit(:name, :citation_style)
        end
end
