class Entity < ApplicationRecord
    # many-to-many relationship through bibliography_entities
    has_many :bibliography_entities
    has_many :bibliographies, through: :bibliography_entities

    after_save :reindex_parent!

    def reindex_parent!
        bibliographies.each do |bs|
            #puts "\n\nReindexing #{bs.id}..."
            bs.reindex_me
        end
    end

    def to_label
        self.display_name
    end

    validates :name, presence: true
end
