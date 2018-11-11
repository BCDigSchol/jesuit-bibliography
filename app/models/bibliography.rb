class Bibliography < ApplicationRecord
    has_many :comments, inverse_of: :bibliography, dependent: :destroy

    # many-to-many relationship through bibliography_subjects
    has_many :bibliography_subjects, inverse_of: :bibliography, dependent: :destroy
    has_many :subjects, through: :bibliography_subjects

    # many-to-many relationship through bibliography_periods
    has_many :bibliography_periods, inverse_of: :bibliography, dependent: :destroy
    has_many :periods, through: :bibliography_periods

    # many-to-many relationship through bibliography_locations
    has_many :bibliography_locations, inverse_of: :bibliography, dependent: :destroy
    has_many :locations, through: :bibliography_locations

    # many-to-many relationship through bibliography_entities
    has_many :bibliography_entities, inverse_of: :bibliography, dependent: :destroy
    has_many :entities, through: :bibliography_entities

    # relationship using class_name and foreign_key atributes
    has_many :isbns, class_name: 'StandardIdentifier', foreign_key: 'isbn_id', inverse_of: 'isbn', dependent: :destroy
    has_many :issns, class_name: 'StandardIdentifier', foreign_key: 'issn_id', inverse_of: 'issn', dependent: :destroy
    has_many :dois,  class_name: 'StandardIdentifier', foreign_key: 'doi_id',  inverse_of: 'doi', dependent: :destroy

    # relationship using class_name and foreign_key atributes
    has_many :authors, class_name: 'Citation', foreign_key: 'author_id', inverse_of: 'author', dependent: :destroy
    has_many :editors, class_name: 'Citation', foreign_key: 'editor_id', inverse_of: 'editor', dependent: :destroy
    has_many :author_of_reviews, class_name: 'Citation', foreign_key: 'author_of_review_id', inverse_of: 'author_of_review', dependent: :destroy
    has_many :reviewed_authors, class_name: 'Citation', foreign_key: 'reviewed_author_id', inverse_of: 'reviewed_author', dependent: :destroy
    has_many :translators, class_name: 'Citation', foreign_key: 'translator_id',  inverse_of: 'translator', dependent: :destroy
    has_many :performers, class_name: 'Citation', foreign_key: 'performer_id',  inverse_of: 'performer', dependent: :destroy
    has_many :translated_authors, class_name: 'Citation', foreign_key: 'translated_author_id', inverse_of: 'translated_author', dependent: :destroy

    accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :comments_rejectable?
    accepts_nested_attributes_for :bibliography_subjects, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_periods, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_locations, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :bibliography_entities, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :isbns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :issns, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :dois, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :authors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :editors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :author_of_reviews, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :reviewed_authors, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :translators, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :performers, reject_if: :citations_rejectable?, allow_destroy: true
    accepts_nested_attributes_for :translated_authors, reject_if: :citations_rejectable?, allow_destroy: true

    validates :reference_type, presence: true
    validates :title, presence: true

    private
        def comments_rejectable?(comment)
            comment['body'].blank?
        end

        def citations_rejectable?(citation)
            citation['display_name'].blank?
        end
end