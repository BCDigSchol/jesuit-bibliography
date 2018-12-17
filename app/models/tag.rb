class Tag < ApplicationRecord
    belongs_to :bibliography, optional: true
end
