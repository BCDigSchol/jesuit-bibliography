# Builder template for rendering a single Bibliography record
# as XML (TEI)
xml.bibl(id: bib.id, n: 'M') {

    # Creation date of record in Y-m-d
    xml.date(format_creation_date(bib.created_at), n: "created")

    xml.title bib.display_title

    if bib.periods[0]
        xml.tag!('note', bib.periods[0].name, type: 'classification_period',)
    end

    # Subjects, locations, and entities are all
    # <kw type="subject"> elements
    subjects = bib.subjects.map {|subject| subject.name}
    subjects += bib.locations.map {|location| location.name}
    subjects += bib.entities.map {|entity| entity.name}

    subjects.each do |subj|
        xml.kw(subj, type: 'subject')
    end

    if bib.abstract
        xml.note(bib.abstract, type: 'abstract')
    end

    bib.languages.each do |lang|
        xml.note lang.name, type: 'language'
    end

    bib.journals.each do |journal|
        xml.title(journal.name, level: 'j')
    end

    bib.authors.each do |author|
        xml << render(:partial => 'api/tei_name', :locals => {:name => author.person.name, tag: 'author', role: 'author'})
    end

    bib.author_of_reviews.each do |author|
        xml << render(:partial => 'api/tei_name', :locals => {:name => author.person.name, tag: 'author', role: 'author'})
    end

    bib.editors.each do |editor|
        xml << render(:partial => 'api/tei_name', :locals => {:name => editor.person.name, tag: 'editor', role: 'editor'})
    end

    bib.book_editors.each do |editor|
        xml << render(:partial => 'api/tei_name', :locals => {:name => editor.person.name, tag: 'editor', role: 'editor'})
    end

    bib.translators.each do |translator|
        xml << render(:partial => 'api/tei_name', :locals => {:name => translator.person.name, tag: 'editor', role:'translator'})
    end

    xml.imprint {
        # Only assign a <date> if the year published is really
        # a year published.
        # @TODO smarter date parsing to accommodate things like "1932?" or "1812-1814"
        #
        xml.date(bib.year_published.to_i)

        if bib.publish_places.length > 0
            xml.pubPlace(bib.publish_places[0].name)
        end

        if bib.publishers.length > 0
            xml.publisher(bib.publishers[0].name)
        end
    }

    bib.isbns.each do |isbn|
        xml.idno(isbn.value, type: 'isbn')
    end

    bib.issns.each do |issn|
        xml.idno(issn.value, type: 'issn')
    end

    bib.dois.each do |doi|
        xml.idno(doi.value, type: 'doi')
    end

    if bib.page_range
        xml.biblScope bib.page_range, type: "pages"
    end

    if bib.issue
        xml.biblScope bib.issue, type: "issue"
    end

    if bib.issue
        xml.biblScope bib.issue, type: "volume"
    end

    if bib.book_title
        xml.title(bib.book_title, level: "m")
    end

    # Smash reviews into <comment> elements.
    bib.reviewed_components.each do |component|
        xml.comment(reviewed_component_comment(component), type: 'comment')
    end

    bib.comments.each do |comment|
        xml.note(comment.body, type: "comment")
    end
}