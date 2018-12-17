class DissertationUniversity < ApplicationRecord
    belongs_to :bibliography, optional: true
end
