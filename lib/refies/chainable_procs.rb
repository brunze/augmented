module Refies
  module ChainableProcs
    refine Proc do

      def | other
        -> (*args) { other.to_proc.call self.call(*args) }
      end

    end
  end
end