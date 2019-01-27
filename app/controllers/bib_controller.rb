class BibController < ApplicationController
    before_action :set_bib

    def raw
        respond_to do |format|
            format.html { render body: @bib.bibtex }
            format.json  { render body: @bib.bibtex }
        end
    end
    def mla
        respond_to do |format|
            format.html { render body: @bib.bibtex_mla }
            format.json  { render body: @bib.bibtex_mla }
        end
    end
    def chicago
        respond_to do |format|
            format.html { render body: @bib.bibtex_chicago }
            format.json  { render body: @bib.bibtex_chicago }
        end
    end
    def turabian
        respond_to do |format|
            format.html { render body: @bib.bibtex_turabian }
            format.json  { render body: @bib.bibtex_turabian }
        end
    end

    private
        def set_bib
            begin
                @bib = Bibliography.find(params[:bibliography_id])

                # make sure we only pull from published records
                if !@bib.published?
                    raise ActiveRecord::RecordNotFound
                end
                #authorize! :read, Bibliography
            rescue ActiveRecord::RecordNotFound => e
                respond_to do |format|
                    format.html { return head(:not_found) }
                    format.json { return head(:not_found) }
                end
            end
        end
end