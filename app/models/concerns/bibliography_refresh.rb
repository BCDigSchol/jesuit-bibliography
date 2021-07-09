module BibliographyRefresh
    extend ActiveSupport::Concern

    # reindex associated bibliography record.
    # note: this is only applicable for models with a belongs_to relationship to Bibliography
    def reindex_parent!
        bibliography.refresh
        Sunspot.index! bibliography
    end
end