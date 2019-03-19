bibs.each do |bib|
    xml << render(:partial => 'api/bibl', :locals => {:bib => bib})
end