module QueryObjects

  class ControlledVocabularyTermQuery

    # Initialize
    #
    # @param [Relation] relation an active record relation
    # @param [Object] params
    def initialize(params = {}, relation)
      @relation = relation
      @params = params
    end

    # Request a list of controlled vocabulary terms
    def all()

      # TODO allow blank terms?
      term = @params[:term]

      # allow for wildcard searches.
      if term == '*'
        default_where_clause = "true = true"
      else
        # TODO handle special chars like in 'Marszał'
        default_where_clause = "LOWER(name) LIKE LOWER(?) OR LOWER(sort_name) LIKE LOWER(?)", "%#{term}%", "%#{term}%"
      end

      @relation.where(default_where_clause)
        .order(:sort_name)
        .map { |item| {id: item.id, text: item.name} }
    end
  end
end