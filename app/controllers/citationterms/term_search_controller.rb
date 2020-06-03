class Citationterms::TermSearchController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource

    before_action :require_login
    before_action :authenticate_user!

    CONTROLLED_VOCABS = {
      :subjects => Subject,
      :jesuits => Entity,
      :locations => Location,
      :journals => Journal,
      :languages => Language,
      :centuries => Period,
      :people => Person
    }

    def index
        authorize! :create, Bibliography

        # Return an empty list if no proper type is specified
        @items = []

        # Controlled vocabulary types follow a normal format. Bibliographies are
        # a special case.
        type = params[:type].to_sym
        if controlled_vocab?(type)
            @items = search_controlled_vocabularies(type)
        elsif type === :bibliographies
            @items = search_bibliographies
        end

        respond_to do |format|
            format.json {
                render :json => @items
            }
        end
    end

    private

    # Do they want to search a controlled vocabulary?
    #
    # @param [Symbol] type
    # @return [TrueClass, FalseClass]
    def controlled_vocab?(type)
        CONTROLLED_VOCABS.key?(type)
    end

    # Search a controlled vocabulary
    #
    # @param [Symbol] type which vocabulary to search
    def search_controlled_vocabularies(type)
        ::ControlledVocabularyTermQuery.new(params, CONTROLLED_VOCABS[type]).perform
    end

    # Search bibliographies
    #
    def search_bibliographies
        citation_where_clause = "LOWER(display_title) LIKE LOWER(?)", "%#{params[:term]}%"
        Bibliography.where(citation_where_clause)
                   .order(:display_title)
                   .map { |item| {id: item.id, text: item.display_title + " (ID: #{item.id})"} }
    end
end