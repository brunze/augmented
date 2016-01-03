module Augmented
  module Objects
    module Thru
      refine Object do

        # as seen on lodash: https://lodash.com/docs#thru
        def thru &function
          (function || :itself.to_proc).call self
        end

      end
    end
  end
end