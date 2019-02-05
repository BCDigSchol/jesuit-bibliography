require "alphabetical_paginate"

class Terms::LocationsController < ApplicationController
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

        @locations, @alpha_params = Location
                        .order('name ASC')
                        .where.not(name: [nil, '']) # filter out nils and blanks
                        .alpha_paginate(@letter, @alpha_params_options) {|loc| loc.sort_name.downcase}
    end
end
