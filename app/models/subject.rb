class Subject < ApplicationRecord
    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects
    has_many :bibliographies, through: :bibliography_subjects

    after_save :reindex_parent!

    def reindex_parent!
        bibliographies.each do |bs|
            #puts "\n\nReindexing #{bs.id}..."
            bs.reindex_me
        end
    end

    validates :name, presence: true
    validates :sort_name, presence: true
end
