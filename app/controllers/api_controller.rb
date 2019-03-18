class ApiController < ApplicationController

    # List files modified since a specific date
    #
    # Results are in JSON and ordered by modification date
    def list_updated
        since = params[:since] || '2016-01-01'
        page = params[:page] || 1
        per_page = params[:per_page] || 50
        format = params[:format] || 'full'

        ApiInputValidator::validate(since, page, per_page, format)

        partial = format == 'simple' ? 'api/simple' : 'api/full'

        solr_result = Bibliography.search do
            with(:updated_at).greater_than Time.parse(since)
            paginate :page => page, :per_page => per_page
            order_by(:updated_at, :asc)
        end

        render :action => 'list_updated.json', locals: {
            total: solr_result.total,
            partial: partial,
            hits: solr_result.results
        }
    end
end
