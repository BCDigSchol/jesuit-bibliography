class Language < ApplicationRecord
    belongs_to :bibliography, optional: true
end
