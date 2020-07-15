# Functions used by API calls
module ApiHelper
    # Split names lists into individual names
    #
    # @param [String] name name list from a record
    # @return [Array<String>] list of split out strings
    def split_names(name)
        names = name.split(',')
        if names.length < 2
            names[1] = ''
        end
        names[1].strip!
        names
    end

    # Format all dates to Y-m-d
    # @param [Date] date
    # @return [String] formatted date
    def format_creation_date(date)
        date.strftime('%Y%m%d')
    end

    # Bundle all parts of a review into one string
    #
    # TEI results don't split up reviews into their many components. We
    # bundle everything into one string that is returned as a review.
    #
    # @param [ReviewedComponent] reviewed_component
    # @return [String]
    def reviewed_component_comment(reviewed_component)
        title = "Reviewed item: #{reviewed_component.reviewed_title}".gsub('|', ' | ')

        credit_parts = []

        if reviewed_component.reviewed_author
            credit_parts << " by #{reviewed_component.reviewed_author}"
        end

        if reviewed_component.reviewed_translator
            credit_parts << " translated by #{reviewed_component.reviewed_author}"
        end

        if reviewed_component.reviewed_editor
            credit_parts << " edited by #{reviewed_component.reviewed_editor}"
        end

        title + credit_parts.join(',').gsub('|', ' | ') + ';'
    end
end