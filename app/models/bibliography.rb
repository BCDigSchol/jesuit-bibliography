class Bibliography < ApplicationRecord
    has_many :comments, inverse_of: :bibliography, dependent: :destroy

    # one-to-many relationship using class_name and foreign_key atributes
    has_many :isbns, class_name: 'StandardIdentifier', foreign_key: 'isbn_id', inverse_of: 'isbn', dependent: :destroy
    has_many :issns, class_name: 'StandardIdentifier', foreign_key: 'issn_id', inverse_of: 'issn', dependent: :destroy
    has_many :dois,  class_name: 'StandardIdentifier', foreign_key: 'doi_id',  inverse_of: 'doi', dependent: :destroy

    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects, inverse_of: :bibliography, dependent: :destroy
    has_many :subjects, through: :bibliography_subjects

    # many-to-many relationship through bibliography_periods
    has_many :bibliography_periods, inverse_of: :bibliography, dependent: :destroy
    has_many :periods, through: :bibliography_periods

    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :comments_rejectable?
    accepts_nested_attributes_for :bibliography_subjects, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_periods, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :isbns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :issns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :dois, reject_if: :all_blank, allow_destroy: true

    validates :reference_type, presence: true
    validates :title, presence: true

    private
        def comments_rejectable?(comment)
            comment['body'].blank?
        end
end