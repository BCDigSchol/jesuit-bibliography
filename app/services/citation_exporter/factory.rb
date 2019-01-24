module CitationExporter
    module Factory
        def self.get_template(type:)
            if TYPE_TO_TEMPLATE[type]
                TYPE_TO_TEMPLATE[type]
            else
                raise "#{type} is not a valid citation type; use one of #{VALID_KEYS}"
            end
        end

        def self.article_template
            Template.new(
                normal_fields: {
                    :title => :title_text,
                    :journal => :journals_text,
                    :year => :year_published_text,
                    :volume => :volume_text,
                    :issue => :issue_text,
                    :pages => :page_range_text,
                    :abstract => :abstract_text,
                    :edition => :edition_text
                },
                name_fields: {
                    :author => :display_author_text
                },
                bibtex_type: :article
            )
        end

        def self.book_template
            Template.new(
                normal_fields: {
                    title: :display_title_text,
                    year: :year_published_text,
                    publisher: :publishers_text,
                    address: :publish_places_text,
                    abstract: :abstract_text
                },
                name_fields: {
                    author: :display_author_text,
                    editor: :editors_text
                },
                bibtex_type: :book
            )
        end

        def self.book_chapter_template
            Template.new(
                normal_fields: {
                    title: :chapter_title_text,
                    booktitle: :book_title_text,
                    address: :publish_places_text,
                    publisher: :publishers_text,
                    year: :year_published_text,
                    pages: :page_range_text,
                },
                name_fields: {
                    author: :display_author_text,
                    editor: :editors_text
                },
                bibtex_type: :incollection
            )
        end

        def self.dissertation_template
            Template.new(
                normal_fields: {
                    title: :display_title_text,
                    year: :year_published_text,
                    publisher: :publishers_text,
                    address: :publish_places_text,
                    abstract: :abstract_text,
                    school: :dissertation_universities_text
                },
                name_fields: {
                    author: :display_author_text,
                    editor: :editors_text
                },
                bibtex_type: :phdthesis
            )
        end

        def self.conference_paper_template
            Template.new(
                normal_fields: {
                    title: :display_title_text,
                    booktitle: :event_title_text,
                    abstract: :abstract_text,
                    address: :event_location_text,
                    year: :year_published_text,
                    month: :date_text
                },
                name_fields: {
                    author: :display_author_text,
                    editor: :editors_text
                },
                bibtex_type: :inproceedings
            )
        end

        TYPE_TO_TEMPLATE = {
            "Journal Article" => article_template,
            "Book" => book_template,
            "Book Chapter" => book_chapter_template,
            "Multimedia" => book_template,
            "Dissertation" => dissertation_template,
            "Conference Paper" => conference_paper_template
        }

        VALID_KEYS = TYPE_TO_TEMPLATE.keys

    end
end