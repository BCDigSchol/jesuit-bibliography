class Entity < ApplicationRecord
    belongs_to :bibliography, optional: true

    def to_label
        self.display_name
    end
end
