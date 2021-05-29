module Augmented
  module Strings
    module Truncatable
      refine String do

        def truncate length
          raise ArgumentError, 'length must be a non-negative integer' unless length && length.to_int >= 0

          slice(0, length)
        end

        def truncate! length
          replace(truncate(length))
          self
        end

      end
    end
  end
end