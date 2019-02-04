class Entity < ApplicationRecord
    has_many :bibliography_entities, dependent: :destroy
    has_many :bibliographies, through: :bibliography_entities

    after_save :reindex_parent!

    def to_label
        self.display_name
    end

    validates :name, presence: true

    private
        def reindex_parent!
            bibliographies.each do |bs|
                puts "\n\nReindexing ##{bs.id} from Entity ##{self.id}"
                bs.reindex_me
            end
        end
end
