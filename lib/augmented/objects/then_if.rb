module Augmented
  module Objects
    module ThenIf
      refine Object do

        def then_if condition, &function
          apply_function = condition.respond_to?(:call) ? condition.call(self) : condition
          apply_function ? self.then(&function) : self
        end

        def then_unless condition, &function
          skip_function = condition.respond_to?(:call) ? condition.call(self) : condition
          skip_function ? self : self.then(&function)
        end

      end
    end
  end
end