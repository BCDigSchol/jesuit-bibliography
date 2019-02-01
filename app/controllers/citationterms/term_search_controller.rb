class Citationterms::TermSearchController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource

    before_action :require_login
    before_action :authenticate_user!

    def index
        authorize! :create, Bibliography

        # TODO allow blank terms?
        term = params[:term]

        # allow for wildcard searches.
        if term == '*'
            default_where_clause = "true = true"
        else
            # TODO handle special chars like in 'Marszał'
            default_where_clause = "LOWER(name) LIKE LOWER(?) OR LOWER(sort_name) LIKE LOWER(?)", "%#{params[:term]}%", "%#{params[:term]}%"
        end

        case params[:type]
        when "subjects"
            @items = Subject.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "jesuits"
            @items = Entity.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "locations"
            @items = Location.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "journals"
            @items = Journal.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "languages"
            @items = Language.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "centuries"
            @items = Period.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "people"
            @items = Person.where(default_where_clause)
                        .order(:name)
                        .map{|item| {id: item.id, text: item.name}}
        when "bibliographies"
            citation_where_clause = "LOWER(display_title) LIKE LOWER(?)", "%#{params[:term]}%"
            @items = Bibliography.where(citation_where_clause)
                        .order(:display_title)
                        .map{|item| {id: item.id, text: item.display_title + " (ID: #{item.id})"}}
        else
            @items = []
        end

        respond_to do |format|
            format.json {
                render :json => @items
            }
        end
    end
end