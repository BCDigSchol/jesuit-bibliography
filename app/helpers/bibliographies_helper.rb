module BibliographiesHelper
    def creator_match?(current_user, bib_creator)
        current_user.to_s == bib_creator.to_s
    end

    def format_date_string(date)
        # TODO make sure this is a date-type object
        date.in_time_zone('Eastern Time (US & Canada)').strftime "%Y-%m-%d %H:%M %Z"
    end

    def format_field_label(field_label, add_required_flag)
        add_required_flag ||= false
        if add_required_flag
            return field_label.html_safe + Bibliography::REQUIRED_FLAG
        end
        return field_label
    end
end
