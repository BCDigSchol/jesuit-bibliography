# frozen_string_literal: true
class CatalogController < ApplicationController

  include BlacklightRangeLimit::ControllerOverride
  include BlacklightAdvancedSearch::Controller
  include Blacklight::Controller

  include Blacklight::Catalog
  #include Blacklight::Marc::Catalog

  # custom action for homepage
  # normally, a solr query is made when loading the home page in order to load the facets, but
  # since we're not showing the facets on the home page we can avoid the query by using a custom action.
  # likewise, we can use this action name as a classname in the body tag of the Blacklight templates. 
  def job_home 
    params[:q] = "" 
    render :index
  end

  configure_blacklight do |config|
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
      # qt: 'document',
      ## These are hard-coded in the blacklight 'document' requestHandler
      # fl: '*',
      # rows: 1,
      ## Be sure to identify our unique_key id value here: id_i
      ## See models/solr_document.rb
      q: '{!term f=id_i v=$id}'
    }

    # config for fields displayed in the BL 'Cite' tool
    # somehow, we can hide these fields from displaying in the record view by setting the lambda function to return 'false'
    # but this will still appear in the 'Cite' panel
    config.add_show_field 'bibtex_mla_text', label: 'MLA', :helper_method => :display_in_parts, if: lambda {|context, field_config, document|
      false
    }
    config.add_show_field 'bibtex_chicago_text', label: 'Chicago', :helper_method => :display_in_parts, if: lambda {|context, field_config, document|
      false
    }
    config.add_show_field 'bibtex_turabian_text', label: 'Turabian', :helper_method => :display_in_parts, if: lambda {|context, field_config, document|
      false
    }

    # solr field configuration for search results/index views
    # use display_title_text as the generic title_field for index views
    config.index.title_field = 'display_title_text'
    config.index.display_type_field = 'reference_type_text'
    #config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr field configuration for document/show views
    # use display_title_text as the generic title_field for document views
    config.show.title_field = 'display_title_text'
    config.show.display_type_field = 'reference_type_text'
    #config.show.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    #config.add_facet_field 'format', label: 'Format'
    #config.add_facet_field 'pub_date', label: 'Publication Year', single: true
    #config.add_facet_field 'subject_topic_facet', label: 'Topic', limit: 20, index_range: 'A'..'Z'
    #config.add_facet_field 'language_facet', label: 'Language', limit: true
    #config.add_facet_field 'lc_1letter_facet', label: 'Call Number'
    #config.add_facet_field 'subject_geo_facet', label: 'Region'
    #config.add_facet_field 'subject_era_facet', label: 'Era'

    config.add_facet_field 'reference_type_facet', label: 'Format'
    config.add_facet_field 'people_facet', label: 'Authors', limit: 20, index_range: 'A'..'Z'
    config.add_facet_field 'years_published_itm', label: 'Publication Year', range: true
    #config.add_facet_field 'publish_places_facet', label: 'Place Published', limit: 20, index_range: 'A'..'Z'
    config.add_facet_field 'languages_facet', label: 'Languages', limit: 20
    config.add_facet_field 'subjects_facet', label: 'Subjects', limit: 20, index_range: 'A'..'Z'
    config.add_facet_field 'centuries_facet', label: 'Centuries', limit: 20, sort: 'index'
    config.add_facet_field 'locations_facet', label: 'Locations', limit: 20, index_range: 'A'..'Z'
    config.add_facet_field 'jesuits_facet', label: 'Jesuits', limit: 20, index_range: 'A'..'Z'
    
    #config.add_facet_field 'example_pivot_field', label: 'Languages by Format', :pivot => ['reference_type_text', 'language_text']

    #config.add_facet_field 'example_query_facet_field', label: 'Publish Date', :query => {
    #   :years_5 => { label: 'within 5 Years', fq: "pub_date:[#{Time.zone.now.year - 5 } TO *]" },
    #   :years_10 => { label: 'within 10 Years', fq: "pub_date:[#{Time.zone.now.year - 10 } TO *]" },
    #   :years_25 => { label: 'within 25 Years', fq: "pub_date:[#{Time.zone.now.year - 25 } TO *]" }
    #}

    #config.add_facet_field 'example_query_facet_field', label: 'Publication Year range', :query => {
    #     :years_5 => { label: 'within 5 Years', fq: "year_published_text:[#{Time.zone.now.year - 5 } TO *]" },
    #     :years_10 => { label: 'within 10 Years', fq: "year_published_text:[#{Time.zone.now.year - 10 } TO *]" },
    #     :years_25 => { label: 'within 25 Years', fq: "year_published_text:[#{Time.zone.now.year - 25 } TO *]" },
    #     :years_50 => { label: 'within 50 Years', fq: "year_published_text:[#{Time.zone.now.year - 50 } TO *]" },
    #     :years_100 => { label: 'within 100 Years', fq: "year_published_text:[#{Time.zone.now.year - 100 } TO *]" },
    #}


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'display_author_text', label: 'Author', :helper_method => :display_in_parts
    config.add_index_field 'reference_type_text', label: 'Format'
    config.add_index_field 'book_title_text', label: 'Book Title'
    config.add_index_field 'journals_text', label: 'Journal Title'
    config.add_index_field 'dissertation_universities_text', label: 'University', :helper_method => :display_in_parts
    config.add_index_field 'multimedia_type_text', label: 'Type of Media'
    config.add_index_field 'year_published_text', label: 'Year Published'
    config.add_index_field 'abstract_text', label: 'Abstract', :helper_method => :display_in_parts

    #config.add_index_field 'title_display', label: 'Title'
    #config.add_index_field 'id_i', label: 'Bib ID'
    #config.add_index_field 'title_text', label: 'Title'
    #config.add_index_field 'display_title_text', label: 'Display Title'
    #config.add_index_field 'chapter_title_text', label: 'Chapter Title'
    #config.add_index_field 'title_of_review_text', label: 'Title of Review'
    #config.add_index_field 'paper_title_text', label: 'Paper Title'
    #config.add_index_field 'authors_text', label: 'Author', :helper_method => :display_in_parts
    #config.add_index_field 'editors_text', label: 'Editor', :helper_method => :display_in_parts
    #config.add_index_field 'book_editors_text', label: 'Book Editor', :helper_method => :display_in_parts
    #config.add_index_field 'author_of_reviews_text', label: 'Author of Review', :helper_method => :display_in_parts
    #config.add_index_field 'translators_text', label: 'Author of Review', :helper_method => :display_in_parts
    #config.add_index_field 'publish_places_text', label: 'Place published', :helper_method => :display_in_parts
    #config.add_index_field 'languages_text', label: 'Languages', :helper_method => :display_in_parts
    #config.add_index_field 'subjects_text', label: 'Subjects'
    #config.add_index_field 'centuries_text', label: 'Centuries'
    #config.add_index_field 'locations_text', label: 'Locations'
    #config.add_index_field 'jesuits_text', label: 'Jesuits'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'authors_text', label: 'Authors', link_to_search: :people_facet
    config.add_show_field 'book_title_text', label: 'Book Title'
    config.add_show_field 'book_chapter_record_ref_text', label: 'Book Link', :helper_method => :link_to_book_record
    config.add_show_field 'book_editors_text', label: 'Book Editors', link_to_search: :people_facet
    config.add_show_field 'author_of_reviews_text', label: 'Author of Reviews', link_to_search: :people_facet
    config.add_show_field 'editors_text', label: 'Editors', link_to_search: :people_facet
    config.add_show_field 'translators_text', label: 'Translators', link_to_search: :people_facet
    config.add_show_field 'reference_type_text', label: 'Format', link_to_search: :reference_type_facet
    config.add_show_field 'multimedia_type_text', label: 'Multimedia Type'
    config.add_show_field 'year_published_text', label: 'Year', link_to_search: :year_published_text

    config.add_show_field 'dissertation_universities_text', label: 'Universities', :helper_method => :display_in_parts
    config.add_show_field 'publishers_text', label: 'Publishers', :helper_method => :display_in_parts
    config.add_show_field 'publish_places_text', label: 'Places published'

    #config.add_show_field 'title_of_review_text', label: 'Title of Review'
    config.add_show_field 'journals_text', label: 'Journal Title'
    config.add_show_field 'volume_text', label: 'Volume'
    config.add_show_field 'issue_text', label: 'Issue'

    config.add_show_field 'event_panel_title_text', label: 'Panel Title'
    config.add_show_field 'event_title_text', label: 'Conference Title'
    config.add_show_field 'event_location_text', label: 'Conference Location'

    config.add_show_field 'series_multimedium_text', label: 'Multimedia Series', :helper_method => :display_in_parts

    config.add_show_field 'languages_text', label: 'Languages', link_to_search: :languages_facet
    config.add_show_field 'abstract_text', label: 'Abstract', :helper_method => :display_in_parts

    # reviews field goes here
    config.add_show_field 'reviewed_components_text', label: 'Reviewed Component', :helper_method => :display_reviewed_component

    config.add_show_field 'jesuits_text', label: 'Who (Jesuits)', :helper_method => :display_in_parts_entities
    config.add_show_field 'subjects_text', label: 'What (Subjects)', :helper_method => :display_in_parts_subjects
    config.add_show_field 'locations_text', label: 'Where (Locations)', :helper_method => :display_in_parts_locations
    config.add_show_field 'centuries_text', label: 'When (Centuries)', :helper_method => :display_in_parts_periods

    config.add_show_field 'worldcat_urls_text', label: 'Worldcat URL', :helper_method => :make_link
    config.add_show_field 'publisher_urls_text', label: 'Publisher URL', :helper_method => :make_link
    config.add_show_field 'leuven_urls_text', label: 'Other links', :helper_method => :make_link
    config.add_show_field 'event_urls_text', label: 'Conference URL', :helper_method => :make_link
    config.add_show_field 'multimedia_urls_text', label: 'Multimedia URL', :helper_method => :make_link
    
    config.add_show_field 'page_range_text', label: 'Page Range'
    config.add_show_field 'number_of_pages_text', label: 'Number of Pages'
    config.add_show_field 'isbns_text', label: 'ISBN', :helper_method => :display_in_parts
    config.add_show_field 'issns_text', label: 'ISSN', :helper_method => :display_in_parts
    config.add_show_field 'dois_text', label: 'DOI', :helper_method => :make_doi_link

    config.add_show_field 'comments_public_text', label: 'Comments', :helper_method => :display_in_parts

    #config.add_show_field 'title_text', label: 'Title'
    #config.add_show_field 'display_title_text', label: 'Display Title'
    #config.add_show_field 'chapter_title_text', label: 'Chapter Title'
    #config.add_show_field 'title_of_review_text', label: 'Title of Review'
    #config.add_show_field 'paper_title_text', label: 'Paper Title'
    #config.add_show_field 'display_author_text', label: 'Display Author', :helper_method => :make_people_link
    #config.add_show_field 'performers_text', label: 'Performers', link_to_search: :people_facet
    #config.add_show_field 'translated_authors_text', label: 'Translated Authors', link_to_search: :people_facet
    #config.add_show_field 'reviewed_components_text', label: 'Reviewed Author/Title', :helper_method => :display_reviewed_component
    #config.add_show_field 'number_of_volumes_text', label: 'Number of Volumes'
    #config.add_show_field 'edition_text', label: 'Edition'
    #config.add_show_field 'date_text', label: 'Date'
    #config.add_show_field 'reprint_edition_text', label: 'Reprint Edition'
    #config.add_show_field 'translated_title_text', label: 'Translated Title'
    #config.add_show_field 'volume_number_text', label: 'Volume Number'
    #config.add_show_field 'multimedia_dimensions_text', label: 'Multimedia Dimensions'
    #config.add_show_field 'event_institution_text', label: 'Event Institution'
    #config.add_show_field 'event_date_text', label: 'Event Date'
    #config.add_show_field 'dissertation_thesis_type_text', label: 'Thesis Type'
    #config.add_show_field 'journal_title_text', label: 'Journal Title'
    #config.add_show_field 'dissertation_university_urls_text', label: 'University URL', :helper_method => :make_link
    #config.add_show_field 'epub_date_text', label: 'Epub Date'
    #config.add_show_field 'chapter_number_text', label: 'Chapter Number'
    

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        'spellcheck.dictionary': 'title',
        qf: '${title_qf}',
        pf: '${title_pf}'
      }
    end

    #config.add_search_field('author') do |field|
    #  field.solr_parameters = {
    #    'spellcheck.dictionary': 'author',
    #    qf: '${author_qf}',
    #    pf: '${author_pf}'
    #  }
    #end

    config.add_search_field('author') do |field|
      field.solr_parameters = {
        #'spellcheck.dictionary': 'author',
        qf: '${people_qf}',
        pf: '${people_pf}'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    #config.add_search_field('subject') do |field|
    #  field.qt = 'search'
    #  field.solr_parameters = {
    #    'spellcheck.dictionary': 'subject',
    #    qf: '${subject_qf}',
    #    pf: '${subject_pf}'
    #  }
    #end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    #config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', label: 'relevance'
    #config.add_sort_field 'pub_date_sort desc, title_sort asc', label: 'year'
    #config.add_sort_field 'author_sort asc, title_sort asc', label: 'author'
    #config.add_sort_field 'title_sort asc, pub_date_sort desc', label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'

    config.advanced_search = {
        :form_solr_parameters => {
            'facet.field' => %w(years_published_itm),
            'f.languages_facet.facet.limit' => -1, # return all facet values
            'facet.sort' => :index # sort by byte order of values
        }
    }

    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_solr_parameters] ||= {}

    # Hide SMS.
    config.show.document_actions.delete(:sms)
  end
end
