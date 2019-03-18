class BadPaginationError < ApiException
    include Rails.application.routes.url_helpers

    def description
        'The values of page and per_page should be positive.'
    end

    def successful_example
        "https://jesuitonlinebibliography.bc.edu?page=1&per_page=20";
    end

    def http_status
        return 400
    end
end