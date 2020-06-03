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
    self.normal_name = ActiveSupport::Inflector.transliterate(self.sort_name)
  end

  # Reindex bibliographies if name has changed
  #
  def reindex_parent!
    if saved_change_to_name?
      bib_refs.each do |bs|
        puts "\n\nReindexing ##{bs.id} from #{self.class} ##{self.id}"
        bs.reindex_me
      end
    end
  end
end