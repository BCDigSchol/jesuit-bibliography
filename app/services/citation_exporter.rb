require 'bibtex'
require 'citeproc'
require 'csl/styles'
require 'pp'

module CitationExporter
    STYLE_TO_STYLE_FILE = {
        :mla => 'modern-language-association',
        :chicago => 'chicago-fullnote-bibliography'
    }

    def self.convert_to_bibtex(record)
        # puts record.pretty_inspect
        record_type = record[:reference_type_text][0]
        template = Factory.get_template type: record_type
        bib = BibTeX::Bibliography.new
        entry = BibTeX::Entry.new

        entry.type = template.bibtex_type
        entry.key = :entry

        template.normal_fields.each do |bibtex_field, solr_field|
            entry[bibtex_field] = record[solr_field] if record[solr_field]
        end

        template.name_fields.each do |bibtex_field, solr_field|
            names = record[solr_field].join(' and ')
            entry[bibtex_field] = names if record[solr_field]
        end

        bib << entry
        bib
    end

    def export_to_refworks(record)

    end

    def export_to_endnode(record)

    end

    def export_as_rtf(record, format)

    end

    def self.export_as_html(record:, style: :mla, format: :html)
#        puts record.pretty_inspect
        entry = convert_to_bibtex(record)
        style_file = STYLE_TO_STYLE_FILE[style]

        cite_processor = CiteProc::Processor.new style: style_file, format: format
        cite_processor.import entry.to_citeproc
        foo = cite_processor.render :bibliography, id: :entry
        foo[0]
    end
end