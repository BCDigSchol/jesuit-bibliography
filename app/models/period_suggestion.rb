class PeriodSuggestion < ApplicationRecord
  belongs_to :bibliography, optional: true
end
