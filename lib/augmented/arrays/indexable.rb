module Augmented
  module Arrays
    module Indexable
      refine Array do

        def index_by &criterion
          Hash[ self.map(&criterion).zip(self) ]
        end

      end
    end
  end
end