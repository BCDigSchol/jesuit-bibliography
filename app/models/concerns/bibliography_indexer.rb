module BibliographyIndexer

  extend ActiveSupport::Concern

  # public method called to update display_fields and trigger reindex
  def reindex_me
    puts "I'm being reindex: ID##{self.id}\n\n"
    self.set_display_fields
    self.generate_all_citations
    self.save
    #Sunspot.index! [self]
  end

  included do
    searchable(:if => :published) do
      integer :id

      boolean :published

      text :status

      text :created_by do
        created_by if self.created_by.present?
      end

      text :modified_by do
        modified_by if self.modified_by.present?
      end

      # reference_type is a required field
      text :reference_type
      text :reference_type_faceting, :as => 'reference_type_facet'

      text :title do
        title if self.title.present?
      end

      text :title_of_review do
        title_of_review if self.title_of_review.present?
      end

      text :chapter_title do
        chapter_title if self.chapter_title.present?
      end

      string :sort_title do # for sorting by title, ignoring leading A/An/The
        title.downcase.gsub(/^(an?|the)/, '') if self.title.present?
      end

      text :year_published do
        year_published if self.year_published.present?
      end

      text :display_title do
        display_title if self.display_title.present?
      end

      text :display_author do
        display_author if self.display_author.present?
      end

      text :volume do
        volume if self.volume.present?
      end

      # be sure 'number_of_volumes_text' is defined as a 'text_general' field type in solr's managed-schema file
      text :number_of_volumes do
        number_of_volumes if self.number_of_volumes.present?
      end

      text :edition do
        edition if self.edition.present?
      end

      text :date do
        date if self.date.present?
      end

      text :reprint_edition do
        reprint_edition if self.reprint_edition.present?
      end

      text :abstract do
        abstract if self.abstract.present?
      end

      text :translated_author do
        translated_author if self.translated_author.present?
      end

      text :translated_title do
        translated_title if self.translated_title.present?
      end

      text :volume_number do
        volume_number if self.volume_number.present?
      end

      text :multimedia_dimensions do
        multimedia_dimensions if self.multimedia_dimensions.present?
      end

      text :multimedia_type do
        multimedia_type if self.multimedia_type.present?
      end

      text :event_title do
        event_title if self.event_title.present?
      end

      text :event_location do
        event_location if self.event_location.present?
      end

      text :event_institution do
        event_institution if self.event_institution.present?
      end

      text :event_date do
        event_date if self.event_date.present?
      end

      text :event_panel_title do
        event_panel_title if self.event_panel_title.present?
      end

      text :dissertation_thesis_type do
        dissertation_thesis_type if self.dissertation_thesis_type.present?
      end

      # be sure 'number_of_pages_text' is defined as a 'text_general' field type in solr's managed-schema file
      text :number_of_pages do
        number_of_pages if self.number_of_pages.present?
      end

      text :issue do
        issue if self.issue.present?
      end

      text :page_range do
        page_range if self.page_range.present?
      end

      text :epub_date do
        epub_date if self.epub_date.present?
      end

      text :chapter_number do
        chapter_number if self.chapter_number.present?
      end

      text :book_title do
        book_title if self.book_title.present?
      end

      text :book_chapter_record_ref do
        book_chapter_record_ref if self.book_chapter_record_ref.present?
      end

      # generate html block containing both book_title and book_chapter_record_ref
      text :book_title_html

      text :paper_title do
        paper_title if self.paper_title.present?
      end

      text :authors do # for associations
        authors.map { |author| author.person.name }
      end
      text :editors do # for associations
        editors.map { |editor| editor.person.name }
      end
      text :book_editors do # for associations
        book_editors.map { |book_editor| book_editor.person.name }
      end
      text :author_of_reviews do # for associations
        author_of_reviews.map { |author_of_review| author_of_review.person.name }
      end
      text :translators do # for associations
        translators.map { |translator| translator.person.name }
      end
      text :performers do # for associations
        performers.map { |performer| performer.person.name }
      end

      # special facet containing only authors, editors, translators
      text :authors_faceting, :as => 'authors_facet'

      # special facet containing all people types
      text :people_faceting, :as => 'people_facet'

      text :worldcat_urls do # for associations
        worldcat_urls.map { |worldcat_url| worldcat_url.link }
      end
      text :publisher_urls do # for associations
        publisher_urls.map { |publisher_url| publisher_url.link }
      end
      text :leuven_urls do # for associations
        leuven_urls.map { |leuven_url| leuven_url.link }
      end
      text :multimedia_urls do # for associations
        multimedia_urls.map { |multimedia_url| multimedia_url.link }
      end
      text :event_urls do # for associations
        event_urls.map { |event_url| event_url.link }
      end
      text :dissertation_university_urls do # for associations
        dissertation_university_urls.map { |dissertation_university_url| dissertation_university_url.link }
      end

      text :languages do # for associations
        languages.map { |language| language.name }
      end
      text :languages_faceting, :as => 'languages_facet'

      text :journals do # for associations
        journals.map { |journal| journal.name }
      end
      text :journals_faceting, :as => 'journals_facet'

      text :publishers do # for associations
        publishers.map { |publisher| publisher.name }
      end

      text :publish_places do # for associations
        publish_places.map { |publish_place| publish_place.name }
      end
      text :publish_places_faceting, :as => 'publish_places_facet'

      text :dissertation_universities do # for associations
        dissertation_universities.map { |dissertation_university| dissertation_university.name }
      end

      text :series_multimedium do # for associations
        series_multimedium.map { |series_multimedia| series_multimedia.name }
      end

      text :tags do # for associations
        tags.map { |tag| tag.name }
      end

      text :comments_public

      text :reviewed_author
      text :reviewed_editor
      text :reviewed_translator
      text :reviewed_title

      # combine all the reviewed components into an html structure for easy rendering
      text :reviewed_components_html do
        rc_array = []
        reviewed_components.each do |rc|
          rc_array << "<div class='rc-block'>"
          if rc.reviewed_author.present?
            rc_array << "<div class='rc-item'>"
            components = rc.reviewed_author.split(/[|]+/)
            if !components.empty?
              components.each do |c|
                rc_array << "<div class='rc-row'><span class='rc-label'>Author: </span><span class='rc-text'>#{c}</span></div>"
              end
            end
            rc_array << "</div>"
          end
          if rc.reviewed_editor.present?
            rc_array << "<div class='rc-item'>"
            components = rc.reviewed_editor.split(/[|]+/)
            if !components.empty?
              components.each do |c|
                rc_array << "<div class='rc-row'><span class='rc-label'>Editor: </span><span class='rc-text'>#{c}</span></div>"
              end
            end
            rc_array << "</div>"
          end
          if rc.reviewed_translator.present?
            rc_array << "<div class='rc-item'>"
            components = rc.reviewed_translator.split(/[|]+/)
            if !components.empty?
              components.each do |c|
                rc_array << "<div class='rc-row'><span class='rc-label'>Translator: </span><span class='rc-text'>#{c}</span></div>"
              end
            end
            rc_array << "</div>"
          end
          if rc.reviewed_title.present?
            rc_array << "<div class='rc-row'><div class='rc-item'><span class='rc-label'>Title: </span><span class='rc-text'>#{rc.reviewed_title}</span></div></div>"
          end
          if rc.reviewed_title_record_ref.present?
            rc_array << "<div class='rc-row'><div class='rc-item'><span class='rc-record-link'><a href='#{Rails.application.routes.url_helpers.solr_document_path(rc.reviewed_title_record_ref)}'>Go to reviewed item</a></span></div></div>"
          end
          rc_array << "</div>"
        end
        rc_array
      end

      text :isbns do # for associations
        isbns.map { |isbn| isbn.value }
      end
      text :issns do # for associations
        issns.map { |issn| issn.value }
      end
      text :dois do # for associations
        dois.map { |doi| doi.value }
      end
      text :subjects do # for associations
        subjects.map { |subject| subject.name }
      end
      text :subjects_faceting, :as => 'subjects_facet'

      text :locations do # for associations
        locations.map { |location| location.name }
      end
      text :locations_faceting, :as => 'locations_facet'

      text :jesuits do # for associations
        entities.map { |entity| entity.name }
      end
      text :jesuits_faceting, :as => 'jesuits_facet'

      text :centuries do # for associations
        periods.map { |period| period.name }
      end
      text :centuries_faceting, :as => 'centuries_facet'

      integer :years_published, :multiple => true, :trie => true do
        pub_years = year_published.split(/\D/)
        pub_years = pub_years.map { |pub_year| pub_year.to_i }
        if pub_years.count < 2
          pub_years
        else
          start_year = pub_years[0]
          end_year = 2000 + pub_years[1]
          (start_year..end_year).to_a
        end
      end

      text :bibtex do
        bibtex if self.bibtex.present?
      end

      text :bibtex_mla do
        bibtex_mla if self.bibtex_mla.present?
      end

      text :bibtex_chicago do
        bibtex_chicago if self.bibtex_chicago.present?
      end

      text :bibtex_turabian do
        bibtex_turabian if self.bibtex_turabian.present?
      end

      time :created_at
      time :updated_at
    end

  end
end