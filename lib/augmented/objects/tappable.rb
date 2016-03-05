module Augmented
  module Objects
    module Tappable
      refine Object do

        def tap_if condition, &block
          do_tap = condition.respond_to?(:call) ? condition.call(self) : condition
          do_tap ? self.tap(&block) : self
        end

        def tap_unless condition, &block
          skip_tap = condition.respond_to?(:call) ? condition.call(self) : condition
          skip_tap ? self : self.tap(&block)
        end

      end
    end
  end
end