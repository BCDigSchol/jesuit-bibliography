class BookEditor < ApplicationRecord
  belongs_to :bibliography, optional: true
  belongs_to :person, optional: true
end
