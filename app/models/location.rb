class Location < ApplicationRecord
    # many-to-many relationship through bibliography_locations
    has_many :bibliography_locations
    has_many :bibliographies, through: :bibliography_locations

    after_save :reindex_parent!

    def reindex_parent!
        bibliographies.each do |bs|
            #puts "\n\nReindexing #{bs.id}..."
            bs.reindex_me
        end
    end
end
