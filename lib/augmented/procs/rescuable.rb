module Augmented
  module Procs
    module Rescuable
      refine Proc do

        NOT_PROVIDED = Object.new

        def rescues exception_class, return_value = NOT_PROVIDED, &block
          raise ArgumentError, 'must provide a return value or block' if return_value == NOT_PROVIDED && !block_given?

          original = self

          Proc.new do |*args|
            begin
              original.call *args
            rescue exception_class => exception
              block ? block.call(exception) : return_value
            end
          end
        end

      end
    end
  end
end