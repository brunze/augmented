module Augmented
  module Exceptions
    module Chain
      refine Exception do

        def chain
          Enumerator.new do |yielder|
            yielder << exception = self
            yielder << exception while exception = exception.cause
          end
        end

      end
    end
  end
end