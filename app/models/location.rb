class Location < ApplicationRecord
    belongs_to :bibliography, optional: true
end
