class FeaturedrecordsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
    
    #before_action :require_login
    #before_action :authenticate_user!
    before_action :set_featuredrecord, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        authorize! :read, Featuredrecord, :message => "Unable to load this record."

        @records_grid = initialize_grid(Featuredrecord, 
            order:           'featuredrecords.rank',
            order_direction: 'desc'
        )

        @records = Featuredrecord.all
    end

    def show
    end

    def load_all
        @records = Featuredrecord.where(published: :true).order(rank: :desc)

        out_html = "<div id='all-featured-records'>"
        out_json = []
        @records.each do |record|
            out_html << "<div class='featured-record' data-record-rank='#{record.rank}' id='#{record.id}'>#{record.body}</div>"
            out_json << {
                id: record.id, 
                rank: record.rank, 
                body: record.body
            }
        end
        out_html << "</div>"

        respond_to do |format|
            format.html { render body: out_html }
            format.json  { render body: out_json.to_json }
        end

    end

    def new
        @record = Featuredrecord.new
    end

    def edit
    end

    def create
        @record = Featuredrecord.new(featuredrecord_params)

        authorize! :create, @record, :message => "Unable to create this Featured record."

        @record.created_by = current_user

        if @record.save
            respond_to do |format|
                format.html { redirect_to featuredrecord_path(@record), notice: 'Featured Record was successfully created.' }
                format.json { render :show, status: :created, location: @record }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @record.errors, status: :unprocessable_featuredrecord }
            end
        end
    end

    def update
        authorize! :update, @record, :message => "Unable to update this Featured record."

        # copy over subject_params into period_attributes so we can alter it
        record_attributes = featuredrecord_params

        # update modified_by
        record_attributes[:modified_by] = current_user

        if @record.update(record_attributes)
            respond_to do |format|
                format.html { redirect_to featuredrecord_path(@record), notice: 'Featured record was successfully updated.' }
                format.json { render :show, status: :ok, location: @record }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @record.errors, status: :unprocessable_featuredrecord }
            end
        end
    end

    def destroy
        authorize! :destroy, @record, :message => "Unable to destroy this Featured record."

        @record.destroy
        respond_to do |format|
            format.html { redirect_to featuredrecords_path, notice: 'Featured record was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_featuredrecord
            begin
                @record = Featuredrecord.find(params[:id])
                authorize! :read, @record, :message => "Unable to read this Page record."
            rescue ActiveRecord::RecordNotFound => e
                @record = nil
            end
        end

        def featuredrecord_params
            params.require(:featuredrecord).permit(:name, :rank, :published, :body)
        end
end
