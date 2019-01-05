class PersonSuggestion < ApplicationRecord
  belongs_to :bibliography, optional: true
end
