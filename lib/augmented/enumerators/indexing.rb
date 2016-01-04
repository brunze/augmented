module Augmented
  module Enumerators
    module Indexing
      refine Enumerator do

        def index_by &criterion
          Hash[ self.map(&criterion).zip(self) ]
        end

      end
    end
  end
end