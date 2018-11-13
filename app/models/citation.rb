class Citation < ApplicationRecord
    belongs_to :author, class_name: 'Citation', foreign_key: :author_id, optional: true
    belongs_to :editor, class_name: 'Citation', foreign_key: :editor_id, optional: true
    belongs_to :author_of_review, class_name: 'Citation', foreign_key: :author_of_review_id, optional: true
    belongs_to :reviewed_author, class_name: 'Citation', foreign_key: :reviewed_author_id, optional: true
    belongs_to :translator, class_name: 'Citation', foreign_key: :translator_id, optional: true
    belongs_to :performer, class_name: 'Citation', foreign_key: :performer_id, optional: true
    belongs_to :translated_author, class_name: 'Citation', foreign_key: :translated_author_id, optional: true
end
