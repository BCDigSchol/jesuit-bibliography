require 'net/http'

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
            out_html << "<div class='featured-record' data-record-rank='#{record.rank}' data-bibliography-id='#{record.bibliography_id}' id='#{record.id}'>#{record.body}</div>"
            out_json << {
                id: record.id,
                rank: record.rank,
                bib_id: record.bibliography_id,
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
        @record.image = set_image

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

        @record.image = set_image

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
            else
                # pull in referenced Bibliography record
                fetch_related_record
            end
        end

        def featuredrecord_params
            params.require(:featuredrecord).permit(:name, :rank, :published, :body, :bibliography_id)
        end

        def fetch_related_record
            if @record.bibliography_id.present?
                begin
                    @bib = @record.bibliography
                rescue ActiveRecord::RecordNotFound => e
                    @bib.nil
                end
            end
        end

        # Iterate through ISBNs and ISSNs looking for a valid Syndetic cover image
        def set_image
            @record.isbns.each do |isbn|
                url = book_cover_url(isbn: isbn)
                if valid_cover_image?(url)
                    return url
                end
            end

            @record.issns.each do |issn|
                if valid_cover_image?(url)
                    return url
                end
            end

            nil
        end

        # If he URL returns an image bigger than 1kb we will consider it valid
        def valid_cover_image?(url)
            uri = URI(url)
            return (Net::HTTP.get(uri).bytesize > 1200)
        end

        def book_cover_url(isbn: nil, issn: nil)
            base = 'https://proxy-na.hosted.exlibrisgroup.com/exl_rewrite/syndetics.com/index.aspx'

            params = {:client => 'bostonh'}
            if (isbn)
                params[:isbn] = "#{isbn}/MC.jpg"
            elsif (issn)
                params[:issn] = "#{issn}/MC.jpg"
            end

            "#{base}?#{params.to_query}"
        end
end
