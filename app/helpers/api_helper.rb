module ApiHelper
    def split_names(name)
        names = name.split(',')
        if names.length < 2
            names[1] = ''
        end
        names[1].strip!
        names
    end

    def format_creation_date(date)
        date.strftime('%Y%m%d')
    end

    def reviewed_component_comment(reviewed_component)
        title = "Reviewed item: #{reviewed_component.reviewed_title}"

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

        title + credit_parts.join(',') + ';'
    end
end