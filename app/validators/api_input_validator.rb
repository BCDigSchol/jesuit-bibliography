class ApiInputValidator
    def self.validate(since, page, per_page, format)
        validate_pagination page, per_page
        validate_since since
        validate_format format
    end

    private

    def self.validate_format(format)
        valid_formats = ['simple', 'full']
        unless valid_formats.include? format
            raise BadFormatError.new "#{format} is not a valid format"
        end
    end

    def self.validate_pagination(page, per_page)
        if page.to_i < 1
            raise BadPaginationError.new "#{page} is not a valid page number"
        end

        if per_page.to_i < 1
            raise BadPaginationError.new "#{per_page} is not a valid page length"
        end
    end

    def self.validate_since(since)
        y, m, d = since.split '-'
        unless Date.valid_date? y.to_i, m.to_i, d.to_i
            raise BadDateError.new "#{since} is not a valid date"
        end
    end
end