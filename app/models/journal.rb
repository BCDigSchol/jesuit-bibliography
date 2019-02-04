class Journal < ApplicationRecord
    has_many :bibliography_journals, dependent: :destroy
    has_many :bibliographies, through: :bibliography_journals

    after_save :reindex_parent!

    validates :name, presence: true

    private
        def reindex_parent!
            bibliographies.each do |bs|
                puts "\n\nReindexing ##{bs.id} from Journal ##{self.id}"
                bs.reindex_me
            end
        end
end
