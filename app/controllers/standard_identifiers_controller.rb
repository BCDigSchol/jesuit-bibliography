class StandardIdentifiersController < ApplicationController
    private
        def standard_identifier_params
            params.require(:standard_identifier).permit(:id_type, :value, :bibliography_id)
        end
end
