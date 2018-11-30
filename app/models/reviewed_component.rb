class ReviewedComponent < ApplicationRecord
    belongs_to :bibliography, optional: true
end
