json.meta do
  json.pages @presenter.pagination_info
end

json.docs do
  json.array! @presenter.documents do |document|

    title = document['display_title_text'] ? document['display_title_text'][0] : ''
    author = document['display_author_text'] ? document['display_author_text'][0] : ''
    year = document['year_published_text'] ? document['year_published_text'][0] : ''
    format = document['reference_type_text'] ? document['reference_type_text'][0] : ''

    json.id document.id
    json.title title
    json.author author
    json.year year
    json.format format
  end
end
