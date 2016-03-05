module Augmented
  module Objects
    module Iffy
      refine Object do

        def if condition = self
          self if (block_given? ? yield(self) : condition)
        end

        def else *_
          self
        end

      end

      refine NilClass do

        def else alternative
          alternative
        end

      end

      refine FalseClass do

        def else alternative
          alternative
        end

      end

    end
  end
end