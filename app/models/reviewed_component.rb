class ReviewedComponent < ApplicationRecord
    belongs_to :bibliography, optional: true

    validates :reviewed_title, presence: true
end
