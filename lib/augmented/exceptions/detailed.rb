module Augmented
  module Exceptions
    module Detailed
      refine Exception do

        def details
          @_details ||= {}
        end

        def details= details
          @_details = details.to_hash
        end

        def detailed details
          self.details = details.to_hash
          self
        end

      end
    end
  end
end