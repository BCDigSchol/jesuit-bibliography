class SubjectSuggestion < ApplicationRecord
  belongs_to :bibliography, optional: true
end
