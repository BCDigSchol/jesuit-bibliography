class Person < ApplicationRecord
    has_many :citations
    has_many :bibliographies, through: :citations
end
