class Featuredrecord < ApplicationRecord
    belongs_to :bibliography, optional: true

    validates :name, presence: true
    validates :rank, presence: true

    def isbns
        if bibliography.present?
            unless bibliography.isbns.empty?
                return bibliography.isbns.map {|isbn| isbn.value}
            end
        end
        []
    end

    def issns
        if bibliography.present?
            unless bibliography.isbns.empty?
                return bibliography.isbns.map {|issn| issn.value}
            end
        end
        []
    end
end
