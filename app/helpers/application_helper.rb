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
end
