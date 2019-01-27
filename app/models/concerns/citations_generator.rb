module CitationsGenerator
    extend ActiveSupport::Concern
  
    included do
        def generate_all_citations
            @b = BibTeX::Entry.new
            @b.key = :citationrecord
    
            #if ref_type.present? 
            case self.reference_type.downcase
            when 'book'
                # A book with an explicit publisher.
                # Required fields: author/editor, title, publisher, year
                # Optional fields: volume/number, series, address, edition, month, note, key, url
                @b.type = :book
                generate_address
                generate_author
                generate_doi
                generate_edition
                generate_editor
                generate_isbn
                generate_language
                generate_month
                generate_number
                generate_publisher
                generate_pages
                generate_series
                generate_title
                generate_url
                generate_volume
                generate_year
            when 'book chapter'
                # A part of a book, usually untitled. May be a chapter (or section, etc.) and/or a range of pages.
                # Required fields: author/editor, title, chapter/pages, publisher, year
                # Optional fields: volume/number, series, type, address, edition, month, note, key
                @b.type = :inbook
                @b.keywords = "hello and goodbye"
                generate_address
                generate_author
                generate_bookeditor # called as @b.editor
                generate_chapter
                generate_doi
                generate_edition
                generate_editor
                generate_isbn
                generate_language
                generate_month # not used in schema?
                #generate_number_of_volumes # called as @b.volume # might not be called correctly?
                generate_page_range # called as @b.pages
                generate_publisher
                #generate_series
                generate_title
                generate_url
                generate_volume
                generate_year
            when 'book review'
                # An article from a journal or magazine.
                # Required fields: author, title, journal, year, volume
                # Optional fields: number, pages, month, doi, note, key
                @b.type = :article
                generate_author
                generate_doi
                generate_issn
                generate_journal
                generate_language
                generate_month
                generate_number
                generate_page_range # called as @b.pages
                generate_title
                generate_url
                generate_volume
                generate_year
            when 'journal article'
                # An article in a conference proceedings.
                # Required fields: author, title, booktitle, year
                # Optional fields: editor, volume/number, series, pages, address, month, organization, publisher, note, key
                @b.type = :inproceedings
                generate_address
                generate_author
                generate_booktitle
                generate_doi
                #generate_edition
                generate_editor
                generate_issn
                generate_journal
                generate_language
                generate_month
                generate_number
                generate_publisher
                generate_pages
                generate_series
                generate_title
                generate_url
                generate_volume
                generate_year
            when 'dissertation'
                # A Ph.D. thesis.
                # Required fields: author, title, school, year
                # Optional fields: type, address, month, note, key
                if self.dissertation_thesis_type.present? and self.dissertation_thesis_type.downcase.include? "phd"
                    @b.type = :phdthesis
                else
                    @b.type = :mastersthesis
                end
                generate_address
                generate_author
                generate_doi
                generate_editor
                generate_isbn
                generate_language
                generate_month
                generate_number
                #generate_number_of_volumes # called as @b.volume # might not be called correctly?
                generate_school
                generate_series
                generate_title
                generate_url
                generate_year
            when 'conference paper'
                # The same as inproceedings, included for Scribe compatibility.
                # Required fields: author, title, booktitle, year
                # Optional fields: editor, volume/number, series, pages, address, month, organization, publisher, note, key
                @b.type = :conference
                generate_address
                generate_author
                generate_booktitle
                generate_doi
                generate_editor
                generate_issn
                generate_language
                generate_month
                generate_number
                generate_organization
                generate_publisher
                generate_pages
                generate_series
                generate_title
                generate_url
                generate_volume
                generate_year
            when 'multimedia'
                # For use when nothing else fits.
                # Required fields: none
                # Optional fields: author, title, howpublished, month, year, note, key
                @b.type = :misc
                generate_address
                generate_author
                generate_howpublished
                generate_isbn
                generate_language
                generate_publisher
                generate_series
                generate_title
                generate_url
                generate_year
            end
    
            #
            # default bibtex fields
            # https://en.wikipedia.org/wiki/BibTeX#Field_types
            #
    
            # all fields identified by bibtex-ruby
            #
            # abstract annote archive archive_location archive-place
            # authority call-number chapter-number citation-label citation-number
            # collection-title container-title DOI edition event event-place
            # first-reference-note-number genre ISBN issue jurisdiction keyword locator
            # medium note number number-of-pages number-of-volumes original-publisher
            # original-publisher-place original-title page page-first publisher
            # publisher-place references section status title URL version volume
            # year-suffix accessed container event-date issued original-date
            # author editor translator recipient interviewer publisher composer
            # original-publisher original-author container-author collection-editor
            #end
    
            bibliography = BibTeX::Bibliography.new
            bibliography << @b
    
            self.bibtex = bibliography.to_s
    
            #
            # process various citation formats
            #

            citeproc = bibliography.to_citeproc
 
            # create initial CiteProc object
            processor = CiteProc::Processor.new(style: 'modern-language-association', format: 'html', local: 'en')
            processor.import citeproc
            mla_citation = processor.render :bibliography, id: :citationrecord
            self.bibtex_mla = mla_citation[0]

            # process Chicago citation style
            #processor = CiteProc::Processor.new(style: 'chicago-fullnote-bibliography', format: 'html', local: 'en')
            #processor.import citeproc
            processor.engine.style = 'chicago-fullnote-bibliography'
            processor.engine.style.bibliography['subsequent-author-substitute'] = false
            chicago_citation = processor.render :bibliography, id: :citationrecord
            self.bibtex_chicago = chicago_citation[0]
    
            # process Turabian citation style
            #processor = CiteProc::Processor.new(style: 'turabian-fullnote-bibliography', format: 'html', local: 'en')
            #processor.import citeproc
            processor.engine.style = 'turabian-fullnote-bibliography'
            processor.engine.style.bibliography['subsequent-author-substitute'] = false
            turabian_citation = processor.render :bibliography, id: :citationrecord
            self.bibtex_turabian = turabian_citation[0]
        end

        private 

            def generate_address
                # address - Publisher's address (usually just the city, but can be the full address for lesser-known publishers)
                if self.publish_places.present?
                    p = []
                    self.publish_places.each do |pp|
                        p << pp.name
                    end
                    @b.address = "#{p.join(" and ")}"
                end
                if self.event_location.present?
                    @b.address = self.event_location
                end
            end
                
            # annote - An annotation for annotated bibliography styles (not typical)

            def generate_author
                # author - The name(s) of the author(s) (in the case of more than one author, separated by 'and')
                if self.display_author.present?
                    a = []
                    self.display_author.split('|').each do |author|
                        a << author
                    end
                    @b.author =  "#{a.join(" and ")}"
                end
            end

            def generate_bookeditor
                # booktitle - The title of the book, if only part of it is being cited
                if self.book_editors.present?
                    p = []
                    self.book_editors.each do  |editor|
                        p << editor.person.name
                    end
                    @b.editor = "#{p.join(" and ")}"
                end
            end

            def generate_booktitle
                # booktitle - The title of the book, if only part of it is being cited
                if self.book_title.present?
                    @b.booktitle = self.book_title
                end
                if self.event_title.present?
                    @b.booktitle = self.event_title
                end
            end

            def generate_chapter
                # chapter - The chapter number
                if self.chapter_number.present?
                    @b.chapter = self.chapter_number
                end
            end

            # crossref - The key of the cross-referenced entry

            def generate_doi
                # doi - digital object identifier
                if self.dois.present?
                    p = []
                    self.dois.each do |doi| 
                        p << doi.value
                    end
                    @b.doi = "#{p.join(" and ")}"
                end
            end

            def generate_edition
                # edition - The edition of a book, long form (such as "First" or "Second")
                if self.edition.present?
                    @b.edition = self.edition
                end
            end

            def generate_editor
                # editor - The name(s) of the editor(s)
                if self.editors.present?
                    p = []
                    self.editors.each do  |editor|
                        p << editor.person.name
                    end
                    @b.editor = "#{p.join(" and ")}"
                end
            end
                
            def generate_howpublished
                # howpublished - How it was published, if the publishing method is nonstandard
                if self.multimedia_type.present?
                    @b.howpublished = self.multimedia_type
                end
            end

            # institution - The institution that was involved in the publishing, but not necessarily the publisher

            def generate_journal
                # journal - The journal or magazine the work was published in
                if self.journals.present?
                    p = []
                    self.journals.each do |journal| 
                        p << journal.name
                    end
                    @b.journal = "#{p.join(" and ")}"
                end
            end

            def generate_language
                if self.languages.present?
                    p = []
                    self.languages.each do |language| 
                        p << language.name
                    end
                    @b.language = "#{p.join(" and ")}"
                end
            end
            
            def generate_month
                # month - The month of publication (or, if unpublished, the month of creation)
                if self.date.present?
                    @b.month = normalize_month(self.date)
                end
                if self.event_date.present?
                    @b.month = normalize_month(self.event_date)
                end
            end

            # strip out days, ex. "Oct 12-16" => "Oct"
            def normalize_month(month)
                month_down = month.downcase
                if month_down.include? 'jan'
                    month_normalized = '1'
                elsif month_down.include? 'feb'
                    month_normalized = '2'
                elsif month_down.include? 'mar'
                    month_normalized = '3'
                elsif month_down.include? 'apr'
                    month_normalized = '4'
                elsif month_down.include? 'may'
                    month_normalized = '5'
                elsif month_down.include? 'jun'
                    month_normalized = '6'
                elsif month_down.include? 'jul'
                    month_normalized = '7'
                elsif month_down.include? 'aug'
                    month_normalized = '8'
                elsif month_down.include? 'sep'
                    month_normalized = '9'
                elsif month_down.include? 'oct'
                    month_normalized = "10"
                elsif month_down.include? 'nov'
                    month_normalized = '11'
                elsif month_down.include? 'dec'
                    month_normalized = '12'
                else
                    month_normalized = ''
                end
                month_normalized
            end

            # note - Miscellaneous extra information

            def generate_number
                # number - The "(issue) number" of a journal, magazine, or tech-report, if applicable. Note that this is not the "article number" assigned by some journals.
                if self.issue.present?
                    @b.number = self.issue
                end
            end

            def generate_number_of_volumes
                # number - The "(issue) number" of a journal, magazine, or tech-report, if applicable. Note that this is not the "article number" assigned by some journals.
                if self.number_of_volumes.present?
                    @b.number = self.number_of_volumes
                end
            end

            def generate_organization
                # organization - The conference sponsor
                if self.event_institution.present?
                    p = []
                    self.event_institution.split('|').each do |e|
                        p << e 
                    end
                    @b.organization = "#{p.join(" and ")}"
                end
            end

            def generate_pages
                # pages - Page numbers, separated either by commas or double-hyphens.
                if self.number_of_pages.present?
                    @b.pages = self.number_of_pages
                end
            end

            def generate_page_range
                # pages - Page numbers, separated either by commas or double-hyphens.
                if self.page_range.present?
                    @b.pages = self.page_range
                end
            end

            def generate_publisher
                # publisher - The publisher's name
                if self.publishers.present?
                    p = []
                    self.publishers.each do  |publisher|
                        p << publisher.name
                    end
                    @b.publisher = "#{p.join(" and ")}"
                end
            end

            def generate_school
                # school - The school where the thesis was written
                if self.dissertation_universities.present?
                    p = []
                    self.dissertation_universities.each do |u|
                        p << u.name
                    end
                    @b.school = "#{p.join(" and ")}"
                end
            end

            def generate_series
                # series - The series of books the book was published in (e.g. "The Hardy Boys" or "Lecture Notes in Computer Science")
                # used only for multimedia...?
                if self.series_multimedium.present?
                    p = []
                    self.series_multimedium.each do |m|
                        p << m.name
                    end
                    @b.series = "#{p.join(" and ")}"
                end
            end

            def generate_title
                # title - The title of the work
                if self.display_title.present?
                    @b.title = "#{self.display_title}"
                end
            end

            def generate_volume
                # volume - The volume of a journal or multi-volume book
                if self.volume.present?
                    @b.volume = self.volume
                end
            end

            def generate_year
                # year - The year of publication (or, if unpublished, the year of creation)
                if self.year_published.present?
                    @b.year = "#{self.year_published}"
                end
            end

            #
            # additional fields
            #

            # abstract
            #if self.abstract.present?
            #    @b.abstract = self.abstract
            #end

            def generate_isbn
                # ISBN
                if self.isbns.present?
                    p = []
                    self.isbns.each do |isbn| 
                        p << isbn.value
                    end
                    @b.isbn = "#{p.join(" and ")}"
                end
            end

            def generate_issn
                # ISSN
                if self.issns.present?
                    p = []
                    self.issns.each do |issn| 
                        p << issn.value
                    end
                    @b.issn = "#{p.join(" and ")}"
                end
            end

            def generate_url
                # URL - pull from worldcat?
                if self.worldcat_urls.present?
                    p = []
                    self.worldcat_urls.each do |url| 
                        p << url.link
                    end
                    @b.url = "#{p.join(" and ")}"
                end
            end

            def generate_event
                # event
                if self.event_title.present?
                    @b.event = self.event_title
                end

                # event_date
                if self.event_date.present?
                    @b.event_date = self.event_date
                end

                # event_place
                if self.event_location.present?
                    @b.event_place = self.event_location
                end
            end
    end
end