class Comment < ApplicationRecord
  belongs_to :bibliography, optional: true
end
