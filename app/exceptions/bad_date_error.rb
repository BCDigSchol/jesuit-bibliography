class BadDateError < ApiException
    include Rails.application.routes.url_helpers

    def description
        "The value of 'since' was not a valid date. Dates should be in the format YYYY-MM-DD."
    end

    def successful_example
        "https://jesuitonlinebibliography.bc.edu?since=2019-03-14";
    end

    def http_status
        return 400
    end
end