module Augmented
  module Enumerators
    module Indexing
      refine Enumerator do

        def index_by &criterion
          self.each_with_object({}) do |element, index|
            index[criterion.(element)] = element
          end
        end

      end
    end
  end
end