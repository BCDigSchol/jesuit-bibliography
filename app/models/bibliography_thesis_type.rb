class BibliographyThesisType < ApplicationRecord
    belongs_to :bibliography, optional: true
    belongs_to :thesis_type, optional: true

    # we only have two types based on the bibtext standard
    # https://verbosus.com/bibtex-style-examples.html
    CITATION_STYLE_LIST = ['phdthesis', 'mastersthesis'].freeze

    NAME_PLACEHOLDER = 'Save this record before editing this field'.freeze
    CITATION_STYLE_PLACEHOLDER = 'Select the citation style for this thesis type.'.freeze
end
