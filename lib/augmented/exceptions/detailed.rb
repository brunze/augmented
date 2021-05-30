module Augmented
  module Exceptions
    module Detailed
      refine Exception do

        def details
          @_details ||= {}
        end

        def details= **details
          @_details = details
        end

        def detailed **details
          self.details = details
          self
        end

      end
    end
  end
end