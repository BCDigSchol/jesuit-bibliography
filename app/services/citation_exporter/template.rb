module CitationExporter
    class Template
        attr_accessor :bibtex_type

        def initialize(normal_fields:, name_fields:, bibtex_type:)
            @normal_fields = normal_fields
            @name_fields = name_fields
            @bibtex_type = bibtex_type
        end

        def populate(from:, to:, key: :entry)
            # BibTex name lists are joined by ' and ',
            # e.g. 'Ben Florin and Jesse Martinez and Anna Kijas'
            to = populate_fields fields: @name_fields, from: from, to: to, join_string: ' and '
            to = populate_fields fields: @normal_fields, from: from, to: to
            to
        end

        private

        def populate_fields(fields:, from:, to:, join_string: ',')
            fields.each do |bibtex_field, solr_field|
                if from[solr_field]
                    joined = from[solr_field].join(join_string)
                    to[bibtex_field] = joined
                end
            end
            to
        end
    end
end