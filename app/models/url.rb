class Url < ApplicationRecord
    belongs_to :worldcat_url, class_name: 'Url', foreign_key: :worldcat_url_id, optional: true
    belongs_to :publisher_url, class_name: 'Url', foreign_key: :publisher_url_id, optional: true
    belongs_to :leuven_url, class_name: 'Url', foreign_key: :leuven_url_id, optional: true
    belongs_to :multimedia_url, class_name: 'Url', foreign_key: :multimedia_url_id, optional: true
    belongs_to :event_url, class_name: 'Url', foreign_key: :event_url_id, optional: true
    belongs_to :dissertation_university_url, class_name: 'Url', foreign_key: :dissertation_university_url_id, optional: true
end
