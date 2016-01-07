module Augmented
  module Procs
    module Chainable
      refine Proc do

        def | other
          -> *args { other.to_proc.call self.call(*args) }
        end

      end
    end
  end
end