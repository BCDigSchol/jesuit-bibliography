# Builder partial for single TEI name element
xml.tag!(tag, n: name, role: role) {
    name_parts = split_names(name)
    xml.name name_parts[1], type: "first"
    xml.name name_parts[0], type: "last"
}