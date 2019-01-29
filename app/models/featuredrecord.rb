class Featuredrecord < ApplicationRecord
    has_one :bibliography

    validates :name, presence: true
    validates :rank, presence: true
end
