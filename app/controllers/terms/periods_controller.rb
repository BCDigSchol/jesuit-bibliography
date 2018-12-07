require "alphabetical_paginate"

class Terms::PeriodsController < ApplicationController
    include Terms::ControllersHelper

    # use default Blacklight layout
    #layout 'bibliography'

    def index
        default_letter = "0-9"
        @letter = sanitize_letter(params[:letter], default_letter)

        @alpha_params_options = {
            bootstrap3: true,
            include_all: true,
            js: false
        }

        @periods, @alpha_params = Period
                        .order('name ASC')
                        .where.not(name: [nil, '']) # filter out nils and blanks
                        .alpha_paginate(@letter, @alpha_params_options) {|per| per.name.downcase}
    end
end
