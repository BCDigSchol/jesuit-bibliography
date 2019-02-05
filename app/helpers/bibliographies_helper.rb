module BibliographiesHelper
    def creator_match?(current_user, bib_creator)
        current_user.to_s == bib_creator.to_s
    end

    def format_date_string(date)
        # TODO make sure this is a date-type object
        date.in_time_zone('Eastern Time (US & Canada)').strftime "%Y-%m-%d %H:%M %Z"
    end
end
