module ApplicationHelper
    # sample method
    def make_upcase args
        args[:document][args[:field]].map { |v| v.upcase }.join(", ")
    end

    # make field value into a link
    # assumes value is a valid url
    # TODO sanitize field value to avoid potential XSS
    def make_link args
        out = "".html_safe
        args[:document][args[:field]].each do |link|
            out << "<a class='bl-view-link' href='#{link}' target='_blank'>#{link}</a>".html_safe
        end
        out
    end

    # separate parts by html breakrule
    # for now, this method uses a double pipe "||" as the delimiter
    # TODO allow custom delimiters
    def separate_parts args
        out = "".html_safe
        args[:document][args[:field]].each do |part|
            components = part.split("||")
            components.each do |c|
                out << "<div class='dd-part'>#{c}</div>".html_safe
            end
        end
        out
    end
end
