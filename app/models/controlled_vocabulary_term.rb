# Base class for controlled vocabulary terms
#
# Examples: People, Subjects, Locations, Languages, etc.
#
class ControlledVocabularyTerm < ApplicationRecord

  self.abstract_class = true

  # Get bibliographies
  #
  def bib_refs
    self.bibliographies
  end

  # Update normalized name on save
  #
  # The normalized name has diacritics and special characters stripped
  # out. It is not displayed and isn't edited manually.
  #
  before_save do
    if self.sort_name
      sort_name_stripped = self.sort_name.strip
    elsif self.name
      sort_name_stripped = self.name.strip
    end
    self.normal_name = ActiveSupport::Inflector.transliterate(sort_name_stripped)
  end

  # Reindex bibliographies only if name has changed
  def reindex_parents!
    if saved_change_to_attribute?("name")
      bib_refs.each do |bib|
        bib.refresh
      end

      # convert ActiveRecord::Relation object type to array for Sunspot
      bib_refs_array = bib_refs.to_a.map {|u| u}

      # reindex this record's bib_refs in one batch
      Sunspot.index! bib_refs_array
    end
  end
end