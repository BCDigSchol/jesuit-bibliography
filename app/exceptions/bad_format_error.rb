class BadFormatError < ApiException
    def description
        "The only valid format values are 'simple' and 'full'."
    end

    def successful_example
        "https://jesuitonlinebibliography.bc.edu?format=simple"
    end

    def http_status
        return 400
    end
end