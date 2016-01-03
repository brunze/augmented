module Refies
  module IndexableArrays
    refine Array do

      def index_by &criterion
        Hash[ self.map(&criterion).zip(self) ]
      end

    end
  end
end