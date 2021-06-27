module Augmented
  module Objects
    module Tackable
      refine Object do

        def tack name = nil, **functions, &block
          if block_given?
            if name.respond_to?(:to_sym)
              functions.merge!({ name.to_sym => block })
            else
              raise ArgumentError, "invalid function name `#{name.inspect}`"
            end
          end

          functions.each_pair do |name, thing|
            function = case thing
              when Proc, Method, UnboundMethod
                thing
              else
                proc{ thing }
            end
            self.define_singleton_method(name, function)
          end

          self
        end

      end
    end
  end
end