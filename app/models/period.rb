class Period < ApplicationRecord
    belongs_to :bibliography, optional: true
end
