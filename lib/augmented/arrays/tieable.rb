module Augmented
  module Arrays
    module Tieable
      refine Array do

        def tie object = nil, &block
          raise ArgumentError, 'you must provide a non-nil tie object or block' if object.nil? && !block_given?

          tie_function = block_given? ? block : proc{ object }
          ties = self.each_cons(2).map &tie_function

          self.zip(ties).flatten(1)[0...-1]
        end

      end
    end
  end
end