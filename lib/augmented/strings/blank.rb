module Augmented
  module Strings
    module Blank
      REGEXP = /\A[[:space:]]*\z/

      refine String do

        def blank?
          empty? || !!REGEXP.match(self)
        end

      end
    end
  end
end