class LocationSuggestion < ApplicationRecord
  belongs_to :bibliography, optional: true
end
