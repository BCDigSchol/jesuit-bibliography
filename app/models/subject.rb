class Subject < ApplicationRecord
    has_many :bibliography_subjects, dependent: :destroy
    has_many :bibliographies, through: :bibliography_subjects

    after_save :reindex_parent!

    validates :name, presence: true
    #validates :sort_name, presence: true

    def bib_refs
        self.bibliographies
    end

    private
        def reindex_parent!
            bibliographies.each do |bs|
                puts "\n\nReindexing ##{bs.id} from Subject ##{self.id}"
                bs.reindex_me
            end
        end
end
