module Terms::ControllersHelper
    def sanitize_letter(letter, default_letter="A")
      if letter.present?
        if letter.downcase == "all"
          "All"
        elsif letter == "0-9"
          "0-9"
        else
          # sanitize by grabbing first letter only
          # and substitute non-accepted letters with given default_letter
          # https://stackoverflow.com/a/17086441
          @sanitized = letter[0,1].gsub(/[^A-Za-zΑ-Ωα-ωίϊΐόάέύϋΰήώ\*]/, default_letter)
          @sanitized.upcase
        end
      else
        default_letter
      end
    end
  
  end