module Augmented
  module Hashes
    module Mappable
      refine Hash do

        def map_values
          self.each_with_object({}){ |(key, value), result| result[key] = yield value }
        end

        def map_keys
          self.each_with_object({}){ |(key, value), result| result[yield key] = value }
        end

      end
    end
  end
end