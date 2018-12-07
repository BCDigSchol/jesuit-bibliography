class EntitiesController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_entity, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        @entities_grid = initialize_grid(Entity, 
            order:           'entities.name',
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

        if @entity.save
            respond_to do |format|
                format.html { redirect_to @entity, notice: 'Entity was successfully created.' }
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
        if @entity.update!(entity_params)
            respond_to do |format|
                format.html { redirect_to @entity, notice: 'Entity was successfully updated.' }
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
        @entity.destroy
        respond_to do |format|
            format.html { redirect_to entities_path, notice: 'Entity was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_entity
            begin
                @entity = Entity.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                @entity = nil
            end
        end

        def entity_params
            params.require(:entity).permit(:name, :sort_name, :display_name, :birth_date, :death_date)
        end
end
