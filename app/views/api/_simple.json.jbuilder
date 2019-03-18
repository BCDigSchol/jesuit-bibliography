json.id bib.id
json.url solr_document_url(bib.id)
json.title bib.title
json.type bib.reference_type

authors = bib.authors.map {|author| author.person.name}
authors += bib.author_of_reviews.map {|author| author.person.name}
authors += bib.author_of_reviews.map {|author| author.person.name}
authors += bib.editors.map {|editor| editor.person.name}
authors += bib.book_editors.map {|editor| editor.person.name}
authors += bib.translators.map {|translator| translator.person.name}
json.authors authors

json.journals bib.journals.map {|journal| journal.name}
json.publishers bib.publishers.map {|publisher| publisher.name}

subjects = bib.subjects.map {|subject| subject.name}
subjects += bib.periods.map {|period| period.name}
subjects += bib.locations.map {|location| location.name}
subjects += bib.entities.map {|entity| entity.name}
json.subjects = subjects

json.reviewed_titles bib.reviewed_title ? bib.reviewed_title : []
json.reviewed_authors bib.reviewed_author ? bib.reviewed_author : []

json.isbns bib.isbns.map {|isbn| isbn.value}
json.issns bib.issns.map {|issn| issn.value}
json.dois bib.dois.map {|doi| doi.value}

json.abstract bib.abstract

json.created bib.created_at
json.updated bib.updated_at