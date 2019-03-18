json.id bib.id
json.url solr_document_url(bib.id)
json.title bib.title
json.type bib.reference_type

json.authors bib.authors.map {|author| author.person.name}
json.author_of_reviews bib.author_of_reviews.map {|author| author.person.name}
json.editors bib.editors.map {|editor| editor.person.name}
json.book_editors bib.book_editors.map {|editor| editor.person.name}
json.translators bib.translators.map {|translator| translator.person.name}

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

json.created bib.created_at
json.updated bib.updated_at