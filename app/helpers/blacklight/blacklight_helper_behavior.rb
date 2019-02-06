module Blacklight::BlacklightHelperBehavior
    #
    # overriding default Blacklight methods
    # https://github.com/projectblacklight/blacklight/blob/v6.19.2/app/helpers/blacklight/blacklight_helper_behavior.rb
    #

    ##
    # Render classes for the <body> element
    # @return [String]
    def render_body_class
        # tack on a special class names for pages to distinguish between 'home' pages and others
        if controller.controller_name == 'catalog'
            if controller.action_name == 'job_home' or (controller.action_name == 'index' and !has_search_parameters?)
                extra_body_classes << ['blacklight-homepages']
            else
                extra_body_classes << ['blacklight-recordpages']
            end
        else
            extra_body_classes << ['blacklight-otherpages']
        end
        extra_body_classes.join " "
    end

    ##
    # List of classes to be applied to the <body> element
    # @see render_body_class
    # @return [Array<String>]
    def extra_body_classes
        @extra_body_classes ||= ['blacklight-' + controller.controller_name, 'blacklight-' + [controller.controller_name, controller.action_name].join('-')]
    end
end