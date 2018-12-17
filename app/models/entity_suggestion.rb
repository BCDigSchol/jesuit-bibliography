class EntitySuggestion < ApplicationRecord
  belongs_to :bibliography, optional: true
end
