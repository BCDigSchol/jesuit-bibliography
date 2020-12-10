# RailsAdmin configuration for Bibliography model
#
# Configuration for the Bibliography model is included separately
# from the rails_admin initializer because it is complex and prone
# to change.
#
module BibliographyAdmin
    extend ActiveSupport::Concern

    included do

        rails_admin do
            navigation_label 'All records'
            weight -4
            label 'Citation'
            label_plural 'Citations'

            # Exportable fields.
            export do

                field :id
                field :reference_type
                field :year_published
                field :title
                field :volume
                field :number_of_volumes
                field :edition
                field :date
                field :reprint_edition
                field :abstract
                field :translated_title
                field :created_at
                field :updated_at
                field :volume_number
                field :multimedia_dimensions
                field :multimedia_type
                field :event_title
                field :event_location
                field :event_institution
                field :event_date
                field :event_panel_title
                field :dissertation_thesis_type
                field :number_of_pages
                field :journal_title
                field :issue
                field :page_range
                field :epub_date
                field :chapter_number
                field :book_title
                field :title_of_review
                field :chapter_title
                field :display_title
                field :display_year
                field :display_author
                field :paper_title
                field :published
                field :status
                field :created_by
                field :modified_by
                field :bibtex
                field :bibtex_mla
                field :bibtex_chicago
                field :bibtex_turabian
                field :book_chapter_record_ref
                field :translated_author

                # Generated field
                field :display_editors

                # Fields below are all relations.
                field :featuredrecord
                field :comments
                field :reviewed_components
                field :publishers
                field :publish_places
                field :dissertation_universities
                field :series_multimedium
                field :tags
                field :subject_suggestions
                field :location_suggestions
                field :entity_suggestions
                field :period_suggestions
                field :language_suggestions
                field :person_suggestions
                field :journal_suggestions
                field :authors
                field :people
                field :editors
                field :translators
                field :book_editors
                field :author_of_reviews
                field :performers
                field :bibliography_subjects
                field :subjects
                field :bibliography_periods
                field :periods
                field :bibliography_locations
                field :locations
                field :bibliography_entities
                field :entities
                field :bibliography_languages
                field :languages
                field :bibliography_journals
                field :journals
                field :isbns
                field :issns
                field :dois
                field :worldcat_urls
                field :publisher_urls
                field :leuven_urls
                field :multimedia_urls
                field :event_urls
                field :dissertation_university_urls

            end

            object_label_method { :display_title }
        end

    end
end