module Augmented
  module Objects
    module Tackable
      refine Object do

        def tack **functions
          functions.each_pair do |name, thing|
            function = case thing
                        when Proc, Method, UnboundMethod then thing
                        else proc{ thing } end

            self.define_singleton_method name, function
          end

          self
        end

      end
    end
  end
end