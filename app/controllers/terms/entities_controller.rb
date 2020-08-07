require "alphabetical_paginate"

class Terms::EntitiesController < ApplicationController
    include Terms::ControllersHelper

    # use default Blacklight layout
    #layout 'bibliography'

    def index
        default_letter = "A"
        @letter = sanitize_letter(params[:letter], default_letter)

        @alpha_params_options = {
            bootstrap3: true,
            include_all: true,
            js: false
        }

        @entities, @alpha_params = Entity
                        .order('normal_name')
                        .where.not(display_name: [nil, '']) # filter out nils and blanks
                        .alpha_paginate(@letter, @alpha_params_options) {|entity| entity.normal_name.downcase}
    end
end
