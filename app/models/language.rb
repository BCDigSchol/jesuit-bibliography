class Language < ApplicationRecord
    #belongs_to :bibliography, optional: true
    has_many :bibliography_languages
    has_many :bibliographies, through: :bibliography_languages

    after_save :reindex_parent!

    def reindex_parent!
        bibliographies.each do |bs|
            #puts "\n\nReindexing #{bs.id}..."
            bs.reindex_me
        end
    end

    validates :name, presence: true
end
