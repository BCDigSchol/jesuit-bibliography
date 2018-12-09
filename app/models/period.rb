class Period < ApplicationRecord
    # many-to-many relationship through bibliography_periods
    has_many :bibliography_periods
    has_many :bibliographies, through: :bibliography_periods

    after_save :reindex_parent!

    def reindex_parent!
        bibliographies.each do |bs|
            #puts "\n\nReindexing #{bs.id}..."
            bs.reindex_me
        end
    end
end
