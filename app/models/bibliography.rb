class Bibliography < ApplicationRecord
    has_many :comments, inverse_of: :bibliography, dependent: :destroy

    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects, inverse_of: :bibliography, dependent: :destroy
    has_many :subjects, through: :bibliography_subjects

    # many-to-many relationship through bibliography_periods
    has_many :bibliography_periods, inverse_of: :bibliography, dependent: :destroy
    has_many :periods, through: :bibliography_periods

    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :comments_rejectable?
    accepts_nested_attributes_for :bibliography_subjects, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_periods, reject_if: :all_blank, allow_destroy: true

    validates :reference_type, presence: true
    validates :title, presence: true

    private
        def comments_rejectable?(comment)
            comment['body'].blank?
        end
end