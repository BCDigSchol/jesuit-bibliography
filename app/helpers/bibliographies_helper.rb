module BibliographiesHelper
    def creator_match?(current_user, bib_creator)
        current_user.to_s == bib_creator.to_s
    end
end
