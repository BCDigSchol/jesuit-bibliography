class Subject < ApplicationRecord
    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects
    has_many :bibliographies, through: :bibliography_subjects

    validates :name, presence: true
    validates :sort_name, presence: true
end
