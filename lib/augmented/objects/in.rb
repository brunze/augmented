module Augmented
  module Objects
    module In
      refine Object do

        def in? collection
          collection.include?(self)
        end

      end
    end
  end
end