module Augmented
  module Symbols
    module Comparing
      refine Symbol do

        def eq value = NO_VALUE
          Helpers.make_compare_function self, :==, value
        end

        def neq value = NO_VALUE
          Helpers.make_compare_function self, :!=, value
        end

        def lt value = NO_VALUE
          Helpers.make_compare_function self, :<, value
        end

        def lte value = NO_VALUE
          Helpers.make_compare_function self, :<=, value
        end

        def gt value = NO_VALUE
          Helpers.make_compare_function self, :>, value
        end

        def gte value = NO_VALUE
          Helpers.make_compare_function self, :>=, value
        end

      end


      module Helpers

        def self.make_compare_function method_name, operator, value
          if value.equal? NO_VALUE
            -> thing, other { thing.__send__(method_name).__send__(operator, other.__send__(method_name)) }
          else
            -> thing        { thing.__send__(method_name).__send__(operator, value) }
          end
        end

      end

      NO_VALUE = BasicObject.new

      private_constant :NO_VALUE, :Helpers
    end
  end
end