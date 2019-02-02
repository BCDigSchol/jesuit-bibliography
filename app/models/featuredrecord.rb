class Featuredrecord < ApplicationRecord
    belongs_to :bibliography, optional: true

    validates :name, presence: true
    validates :rank, presence: true

    def isbns
        unless bibliography.isbns.empty?
            return bibliography.isbns.map {|isbn| isbn.value}
        end
        []
    end

    def issns
        unless bibliography.isbns.empty?
            return bibliography.isbns.map {|issn| issn.value}
        end
        []
    end
end
