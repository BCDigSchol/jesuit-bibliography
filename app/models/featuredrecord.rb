class Featuredrecord < ApplicationRecord
    belongs_to :bibliography, optional: true

    validates :name, presence: true
    validates :rank, presence: true
end
