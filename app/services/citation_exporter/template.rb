module CitationExporter
    class Template
        attr_accessor :normal_fields, :name_fields, :bibtex_type

        def initialize(normal_fields:, name_fields:, bibtex_type:)
            @normal_fields = normal_fields
            @name_fields = name_fields
            @bibtex_type = bibtex_type
        end
    end
end