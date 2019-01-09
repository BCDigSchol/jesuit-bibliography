module ApplicationHelper
    # sample method
    def make_upcase args
        args[:document][args[:field]].map { |v| v.upcase }.join(", ")
    end

    # make field value into a link
    # for now, this method uses a single pipe "|" as the delimiter;
    # assumes value is a valid url
    # TODO sanitize field value to avoid potential XSS
    def make_link args
        out = "".html_safe
        args[:document][args[:field]].each do |part|
            components = part.split("|")
            if !components.empty?
                components.each do |link|
                    out << "<div class='dd-part'><a class='bl-view-link' href='#{link}' target='_blank'>#{link}</a></div>".html_safe
                end
            end
        end
        out
    end

    # make field value into a link
    # for now, this method uses a single pipe "|" as the delimiter;
    # assumes value is a valid url
    # TODO sanitize field value to avoid potential XSS
    def make_people_link args
        out = "".html_safe
        args[:document][args[:field]].each do |part|
            components = part.split("|")
            if !components.empty?
                components.each do |link|
                    out << "<div class='dd-part'><a class='bl-view-link' href='/?search_field=people&q=\"#{link}\"' target='_blank'>#{link}</a></div>".html_safe
                end
            end
        end
        out
    end

    # make field value into a DOI link
    # for now, this method uses a single pipe "|" as the delimiter;
    # assumes value is a valid url
    # TODO sanitize field value to avoid potential XSS
    def make_doi_link args
        out = "".html_safe
        args[:document][args[:field]].each do |part|
            components = part.split("|")
            if !components.empty?
                components.each do |link|
                    out << "<div class='dd-part'><a class='bl-view-link' href='https://hdl.handle.net/#{link}' target='_blank'>#{link}</a></div>".html_safe
                end
            end
        end
        out
    end

    # split field value into parts with html element wrappers.
    # this method allow for single or double (or more) pipes as a delimiter.
    # can be extended to allow other delimiters
    def display_in_parts args
        out = "".html_safe
        args[:document][args[:field]].each do |part|
            components = part.split(/[|]+/)
            if !components.empty?
                components.each do |c|
                    out << "<div class='dd-part'>#{c}</div>".html_safe
                end
            end
        end
        out
    end

    # split field value into parts with html element wrappers.
    # this method allow for single or double (or more) pipes as a delimiter.
    # can be extended to allow other delimiters
    def display_reviewed_component args
        out = "".html_safe
        args[:document][args[:field]].each do |part|
            components = part.split(/[|]+/)
            if !components.empty?
                components.each do |c|
                    out << "#{c}".html_safe
                end
            end
        end
        out
    end
end
