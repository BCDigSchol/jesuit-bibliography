json.meta do
  json.pages @presenter.pagination_info
end

json.docs do
  json.array! @presenter.documents do |document|
    json.id document.id
    json.title document['display_title_text'][0]
    json.author document['display_author_text'][0]
    json.year document['year_published_text'][0]
    json.format document['reference_type_text'][0]
  end
end
