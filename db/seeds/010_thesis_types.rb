# CREATED_BY_USER is defined in lib/tasks/importdata.rake
# so we'll use that value here
#CREATED_BY_USER        = "admin"
CITATION_STYLE_PHD     = "phdthesis"
CITATION_STYLE_MASTERS = "mastersthesis"

ThesisType.find_or_create_by(name: 'Ph.D.') do | thesis_type |
    thesis_type.sort_name = 'Ph.D.'
    thesis_type.normal_name = 'Ph.D.'
    thesis_type.citation_style = CITATION_STYLE_PHD
    thesis_type.created_by = CREATED_BY_USER
end

ThesisType.find_or_create_by(name: 'Masters') do | thesis_type |
    thesis_type.sort_name = 'Masters'
    thesis_type.normal_name = 'Masters'
    thesis_type.citation_style = CITATION_STYLE_MASTERS
    thesis_type.created_by = CREATED_BY_USER
end

ThesisType.find_or_create_by(name: 'Other') do | thesis_type |
    thesis_type.sort_name = 'Other'
    thesis_type.normal_name = 'Other'
    thesis_type.citation_style = CITATION_STYLE_MASTERS
    thesis_type.created_by = CREATED_BY_USER
end
