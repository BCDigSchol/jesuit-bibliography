class Language < ApplicationRecord
    has_many :bibliography_languages, dependent: :destroy
    has_many :bibliographies, through: :bibliography_languages

    after_save :reindex_parent!

    validates :name, presence: true

    def bib_refs
        self.bibliographies
    end

    private
        def reindex_parent!
            bibliographies.each do |bs|
                puts "\n\nReindexing ##{bs.id} from Language ##{self.id}"
                bs.reindex_me
            end
        end
end
