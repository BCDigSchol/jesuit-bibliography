class Subject < ApplicationRecord
    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects
    has_many :bibliographies, through: :bibliography_subjects

    validates :term_type, presence: true
    validates :name, presence: true
end
