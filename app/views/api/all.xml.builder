# Builder template for entire XML (TEI) document
bibs.each do |bib|

    # Render each bib using the <bibl> partial
    xml << render(:partial => 'api/bibl', :locals => {:bib => bib})
end