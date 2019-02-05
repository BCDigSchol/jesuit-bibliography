class Publisher < ApplicationRecord
    belongs_to :bibliography, optional: true

    validates :name, presence: true
end
