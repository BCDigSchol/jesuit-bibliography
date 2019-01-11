class JournalSuggestion < ApplicationRecord
  belongs_to :bibliography, optional: true
end
