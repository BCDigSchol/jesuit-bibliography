class StandardIdentifier < ApplicationRecord
    belongs_to :isbn, class_name: 'Bibliography', foreign_key: :isbn_id, optional: true
    belongs_to :issn, class_name: 'Bibliography', foreign_key: :issn_id, optional: true
    belongs_to :doi,  class_name: 'Bibliography', foreign_key: :doi_id, optional: true
end
