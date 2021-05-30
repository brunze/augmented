module Augmented
  module Exceptions
    module Hashable
      refine Exception do
        using Chain
        using Detailed

        def to_h
          self.chain.map do |exception|
            {
              class: exception.class.name,
              message: exception.message,
              details: exception.details,
              cause: nil,
            }
          end.reverse.reduce do |cause, exception|
            exception.merge!(cause: cause)
          end
        end

      end
    end
  end
end