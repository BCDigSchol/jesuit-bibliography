class ApiException < StandardError
    def initialize(message)
        if self.class == ApiException
            raise 'Do not instantiate ApiException'
        end
        super(message)
    end

    def successful_example
        raise 'Must implement successful_example'
    end

    def description
        raise 'Must implement explanation'
    end

    def http_status
        raise 'Must implement http_status'
    end
end