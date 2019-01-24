class BibController < ApplicationController
    before_action :set_bib, only: [:index]

    def index
        respond_to do |format|
            format.html { render body: generate_bib }
            format.json  { render body: generate_bib }
        end
    end

    private

        def generate_bib
            out = ""

            if !@bib.nil? and @bib.reference_type.present? and @bib.published? 
                case @bib.reference_type.downcase
                when 'book'
                    out << "@book{citationrecord"
                when 'book chapter'
                    out << "@inbook{citationrecord"
                when 'book review'
                    out << "@article{citationrecord"
                when 'journal article'
                    out << "@inproceedings{citationrecord"
                when 'dissertation'
                    out << "@masterthesis{citationrecord"
                when 'conference paper'
                    out << "@conference{citationrecord"
                when 'multimedia'
                    out << "@misc{citationrecord"
                end

                if @bib.display_author.present?
                    a = []
                    @bib.display_author.split('|').each do |author|
                        a << author
                    end
                    out << ", author = '#{a.join(" and ")}'"
                end
                if @bib.display_title.present?
                    out << ", title = '#{@bib.display_title}'"
                end
                if @bib.year_published.present?
                    out << ", year = '#{@bib.year_published}'"
                end
                if @bib.publishers.present?
                    p = []
                    @bib.publishers.each do  |publisher|
                        p << publisher.name
                    end
                    out << ", publisher = '#{p.join(" and ")}'"
                end
                out << "}"
            
            end

            out
        end

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