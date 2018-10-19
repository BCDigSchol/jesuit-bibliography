class Bibliography < ApplicationRecord
    has_many :comments, dependent: :destroy

    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: ->(comments){ comments['body'].blank? }

    validates :reference_type, presence: true
    validates :title, presence: true
end