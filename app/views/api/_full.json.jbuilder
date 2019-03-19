json.id bib.id
json.url solr_document_url(bib.id)

json.title bib.display_title
json.edition bib.edition
json.translated_title bib.translated_title

json.type bib.reference_type
json.languages bib.languages.map {|language| language.name}

json.authors bib.authors.map {|author| author.person.name}
json.author_of_reviews bib.author_of_reviews.map {|author| author.person.name}
json.editors bib.editors.map {|editor| editor.person.name}
json.book_editors bib.book_editors.map {|editor| editor.person.name}
json.translators bib.translators.map {|translator| translator.person.name}
json.performers bib.performers.map {|performer| performer.person.name}


json.journals bib.journals.map {|journal| journal.name}
json.publishers bib.publishers.map {|publisher| publisher.name}

json.subject bib.subjects.map {|subject| subject.name}
json.periods bib.periods.map {|period| period.name}
json.locations bib.locations.map {|location| location.name}
json.jesuits bib.entities.map {|entity| entity.name}

json.reviewed_titles bib.reviewed_title ? bib.reviewed_title : []
json.reviewed_authors bib.reviewed_author ? bib.reviewed_author : []

json.isbns bib.isbns.map {|isbn| isbn.value}
json.issns bib.issns.map {|issn| issn.value}
json.dois bib.dois.map {|doi| doi.value}

json.abstract bib.abstract

json.places_of_publication bib.publish_places.map {|place| place.name}
json.publishers bib.publishers.map {|publisher| publisher.name}
json.year_published bib.year_published
json.date bib.date

json.page_range bib.page_range
json.page_count bib.number_of_pages
json.chapter_number bib.chapter_number
json.volume bib.volume
json.colume_count bib.number_of_volumes
json.issue bib.issue
json.epub_date bib.epub_date

json.book_title bib.book_title
json.chapter_title bib.chapter_title
json.journal_titles bib.journals.map {|journal| journal.name}
json.paper_title bib.paper_title

json.event_title bib.event_title
json.event_location bib.event_location
json.event_institution bib.event_institution
json.event_date bib.event_date
json.event_panel_title bib.event_panel_title

json.multimedia_type bib.multimedia_type
json.multimedia_dimensions bib.multimedia_dimensions

json.dissertation_universities bib.dissertation_universities.map {|uni| uni.name}
json.dissertation_thesis_type bib.dissertation_thesis_type

json.comments bib.comments.map {|comment| comment.body}

json.created bib.created_at
json.updated bib.updated_at