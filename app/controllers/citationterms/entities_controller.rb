class Citationterms::EntitiesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_entity, only: [:show, :edit, :update, :destroy, :references]

    layout 'bibliography'

    def index
        authorize! :read, Entity, :message => "Unable to load this page."

        @entities_grid = initialize_grid(Entity, 
            order:           'entities.sort_name',
            order_direction: 'asc'
        )

        @entities = Entity.all
    end

    def show
    end

    def new
        @entity = Entity.new
    end

    def edit
    end

    def create
        @entity = Entity.new(entity_params)

        authorize! :create, @entity, :message => "Unable to create this Entity record."

        @entity.created_by = current_user

        @entity.sort_name = @entity.name

        @entity.display_name = @entity.name

        if @entity.save
            respond_to do |format|
                format.html { redirect_to citationterms_entity_path(@entity), notice: 'Entity was successfully created.' }
                format.json { render :show, status: :created, location: @entity }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @entity.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        authorize! :update, @entity, :message => "Unable to update this Entity record."

        # copy over subject_params into period_attributes so we can alter it
        entity_attributes = entity_params

        # update modified_by
        entity_attributes[:modified_by] = current_user

        # fill in sort_name, display_name if they are empty
        if entity_attributes[:sort_name].empty?
            entity_attributes[:sort_name] = @entity.name
        end
        #if entity_attributes[:display_name].empty?
        #    entity_attributes[:display_name] = @entity.name
        #end

        if @entity.update(entity_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_entity_path(@entity), notice: 'Entity was successfully updated.' }
                format.json { render :show, status: :ok, location: @entity }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @entity.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        authorize! :destroy, @entity, :message => "Unable to destroy this Entity record."

        @entity.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_entities_path, notice: 'Entity was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def references
        @bibs_grid = initialize_grid(@entity.bib_refs)
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_entity
            begin
                @entity = Entity.find(params[:id])
                authorize! :read, @entity, :message => "Unable to read this Entity record."
            rescue ActiveRecord::RecordNotFound => e
                @entity = nil
            end
        end

        def entity_params
            params.require(:entity).permit(:name, :sort_name, :display_name, :birth_date, :death_date)
        end
end
