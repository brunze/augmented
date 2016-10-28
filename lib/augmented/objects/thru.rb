module Augmented
  module Objects
    module Thru
      refine Object do

        # as seen on lodash: https://lodash.com/docs#thru
        def thru &function
          (function || :itself.to_proc).call self
        end

        def thru_if condition, &function
          apply_function = condition.respond_to?(:call) ? condition.call(self) : condition
          apply_function ? self.thru(&function) : self
        end

        def thru_unless condition, &function
          skip_function = condition.respond_to?(:call) ? condition.call(self) : condition
          skip_function ? self : self.thru(&function)
        end

      end
    end
  end
end