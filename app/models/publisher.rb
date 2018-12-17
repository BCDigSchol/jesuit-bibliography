class Publisher < ApplicationRecord
    belongs_to :bibliography, optional: true
end
