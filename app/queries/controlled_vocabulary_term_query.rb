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
  def perform()

    # TODO allow blank terms?
    term = @params[:term]

    # allow for wildcard searches.
    if term == '*'
      default_where_clause = "true = true"
    else
      default_where_clause = "LOWER(name) LIKE LOWER(?) OR LOWER(normal_name) LIKE LOWER(?)", "%#{term}%", "%#{term}%"
    end

    @relation.where(default_where_clause)
      .order(:sort_name)
      .map { |item| {id: item.id, text: item.name} }
  end
end