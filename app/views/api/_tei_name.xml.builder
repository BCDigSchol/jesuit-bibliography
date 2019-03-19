xml.tag!(tag, n: name) {
    name_parts = split_names(name)
    xml.name name_parts[1], type: "first"
    xml.name name_parts[0], type: "last"
}