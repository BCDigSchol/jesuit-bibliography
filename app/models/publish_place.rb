class PublishPlace < ApplicationRecord
    belongs_to :bibliography, optional: true
end
