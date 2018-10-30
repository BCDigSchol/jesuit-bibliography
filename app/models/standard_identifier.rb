class StandardIdentifier < ApplicationRecord
    belongs_to :isbn, class_name: 'Bibliography', optional: true
    belongs_to :issn, class_name: 'Bibliography', optional: true
    belongs_to :doi,  class_name: 'Bibliography', optional: true
end
