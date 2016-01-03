module Refies
  module PolymorphableHashes
    refine Hash do

      def polymorph type_attribute_name = :type
        type = (type_attribute_name if Class === type_attribute_name) ||
               self[type_attribute_name] ||
               self[type_attribute_name.to_s]

        raise ArgumentError, 'missing the type required for polymorph' if type.to_s.empty?

        klass = Class === type ? type : Object.const_get(type.to_s)
        klass.new self
      end

    end
  end
end