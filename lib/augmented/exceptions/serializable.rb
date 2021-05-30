module Augmented
  module Exceptions
    module Serializable
      refine Exception do
        using Chain
        using Detailed

        def to_h
          self.chain.map do |exception|
            {
              class: exception.class.name,
              message: exception.message,
              details: exception.details,
              backtrace: exception.backtrace || [],
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