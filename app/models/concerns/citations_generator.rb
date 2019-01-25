module CitationsGenerator
    extend ActiveSupport::Concern
  
    included do
        def generate_all_citations
            b = BibTeX::Entry.new
            b.key = :citationrecord
    
            #if ref_type.present? 
            case self.reference_type.downcase
            when 'book'
                # A book with an explicit publisher.
                # Required fields: author/editor, title, publisher, year
                # Optional fields: volume/number, series, address, edition, month, note, key, url
                b.type = :book
            when 'book chapter'
                # A part of a book, usually untitled. May be a chapter (or section, etc.) and/or a range of pages.
                # Required fields: author/editor, title, chapter/pages, publisher, year
                # Optional fields: volume/number, series, type, address, edition, month, note, key
                b.type = :inbook
            when 'book review'
                # An article from a journal or magazine.
                # Required fields: author, title, journal, year, volume
                # Optional fields: number, pages, month, doi, note, key
                b.type = :article
            when 'journal article'
                # An article in a conference proceedings.
                # Required fields: author, title, booktitle, year
                # Optional fields: editor, volume/number, series, pages, address, month, organization, publisher, note, key
                b.type = :inproceedings
            when 'dissertation'
                # A Master's thesis.
                # Required fields: author, title, school, year
                # Optional fields: type, address, month, note, key
                b.type = :masterthesis
            when 'conference paper'
                # The same as inproceedings, included for Scribe compatibility.
                # Required fields: author, title, booktitle, year
                # Optional fields: editor, volume/number, series, pages, address, month, organization, publisher, note, key
                b.type = :conference
            when 'multimedia'
                # For use when nothing else fits.
                # Required fields: none
                # Optional fields: author, title, howpublished, month, year, note, key
                b.type = :misc
            end
    
            #
            # default bibtex fields
            # https://en.wikipedia.org/wiki/BibTeX#Field_types
            #
    
            # address - Publisher's address (usually just the city, but can be the full address for lesser-known publishers)
            if self.publish_places.present?
                p = []
                self.publish_places.each do |pp|
                    p << pp.name
                end
                b.address = "#{p.join(", ")}"
            end
            
            # annote - An annotation for annotated bibliography styles (not typical)
    
            # author - The name(s) of the author(s) (in the case of more than one author, separated by 'and')
            if self.display_author.present?
                a = []
                self.display_author.split('|').each do |author|
                    a << author
                end
                b.author =  "#{a.join(" and ")}"
            end
    
            # booktitle - The title of the book, if only part of it is being cited
            if self.book_title.present?
                b.book_title = self.book_title
            end
    
            # chapter - The chapter number
            if self.chapter_number.present?
                b.chapter = self.chapter_number
            end
    
            # crossref - The key of the cross-referenced entry
    
            # doi - digital object identifier
            if self.dois.present?
                p = []
                self.dois.each do |doi| 
                    p << doi.value
                end
                b.doi = "#{p.join(", ")}"
            end
    
            # edition - The edition of a book, long form (such as "First" or "Second")
            if self.edition.present?
                b.edition = self.edition
            end
    
            # editor - The name(s) of the editor(s)
            
            # howpublished - How it was published, if the publishing method is nonstandard
    
            # institution - The institution that was involved in the publishing, but not necessarily the publisher
    
            # journal - The journal or magazine the work was published in
            if self.journals.present?
                p = []
                self.journals.each do |journal| 
                    p << journal.name
                end
                b.doi = "#{p.join(" and ")}"
            end
    
            # month - The month of publication (or, if unpublished, the month of creation)
            if self.date.present?
                b.date = self.date
            end
    
            # note - Miscellaneous extra information
    
            # number - The "(issue) number" of a journal, magazine, or tech-report, if applicable. Note that this is not the "article number" assigned by some journals.
            if self.issue.present?
                b.number = self.issue
            end
    
            # organization - The conference sponsor
            if self.event_institution.present?
                b.organization = self.event_institution
            end
    
            # pages - Page numbers, separated either by commas or double-hyphens.
            if self.number_of_pages.present?
                b.pages = self.number_of_pages
            end
    
            # publisher - The publisher's name
            if self.publishers.present?
                p = []
                self.publishers.each do  |publisher|
                    p << publisher.name
                end
                b.publisher = "#{p.join(" and ")}"
            end
    
            # school - The school where the thesis was written
            if self.dissertation_universities.present?
                p = []
                self.dissertation_universities.each do |u|
                    p << u.name
                end
                b.school = "#{p.join(" and ")}"
            end
    
            # series - The series of books the book was published in (e.g. "The Hardy Boys" or "Lecture Notes in Computer Science")
    
            # title - The title of the work
            if self.display_title.present?
                b.title = "#{self.display_title}"
            end
    
            # volume - The volume of a journal or multi-volume book
            if self.volume.present?
                b.volume = self.volume
            end
    
            # year - The year of publication (or, if unpublished, the year of creation)
            if self.year_published.present?
                b.year = "#{self.year_published}"
            end
    
            #
            # additional fields
            #
    
            # abstract
            if self.abstract.present?
                b.abstract = self.abstract
            end
    
            # ISBN
            if self.isbns.present?
                p = []
                self.isbns.each do |isbn| 
                    p << isbn.value
                end
                b.isbn = "#{p.join(", ")}"
            end
    
            # ISSN
            if self.issns.present?
                p = []
                self.issns.each do |issn| 
                    p << issn.value
                end
                b.issn = "#{p.join(", ")}"
            end
    
            # URL - pull from worldcat?
            if self.worldcat_urls.present?
                p = []
                self.worldcat_urls.each do |url| 
                    p << url.link
                end
                b.url = "#{p.join(", ")}"
            end
    
            # event
            if self.event_title.present?
                b.event = self.event_title
            end
    
            # event_location
            if self.event_location.present?
                b.event_place = self.event_location
            end
    
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
            bibliography << b
    
            self.bib_text_raw = bibliography.to_s
    
            #puts "\n\n#{bibliography}\n\n"
    
            #
            # process various citation formats
            #
    
            #apa_processor = CiteProc::Processor.new(style: :apa, format: 'html', local: 'en')
            #apa_processor.import bibliography.to_citeproc
            #apa_citation = apa_processor.render :bibliography, id: :citationrecord
            #puts "\n\nCitation APA: #{apa_citation[0]}\n\n"
    
            mla_processor = CiteProc::Processor.new(style: 'modern-language-association', format: 'html', local: 'en')
            mla_processor.import bibliography.to_citeproc
            mla_citation = mla_processor.render :bibliography, id: :citationrecord
            #puts "\n\nCitation MLA: #{mla_citation[0]}\n\n"
            self.bib_text_mla = mla_citation[0]
    
            chicago_processor = CiteProc::Processor.new(style: 'chicago-annotated-bibliography', format: 'html', local: 'en')
            chicago_processor.import bibliography.to_citeproc
            chicago_citation = chicago_processor.render :bibliography, id: :citationrecord
            #puts "\n\nCitation Chicago: #{chicago_citation[0]}\n\n"
            self.bib_text_chicago = chicago_citation[0]
    
            turabian_processor = CiteProc::Processor.new(style: 'turabian-fullnote-bibliography', format: 'html', local: 'en')
            turabian_processor.import bibliography.to_citeproc
            turabian_citation = turabian_processor.render :bibliography, id: :citationrecord
            #puts "\n\nCitation Turabian: #{turabian_citation[0]}\n\n"
            self.bib_text_turabian = turabian_citation[0]
            
        end
    end
end