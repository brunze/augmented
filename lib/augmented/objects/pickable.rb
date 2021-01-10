module Augmented
  module Objects
    module Pickable
      refine Object do

        def pick *picks
          ensure_array = -> thing { thing.kind_of?(Array) ? thing : Array[thing] }

          if self.respond_to? :each
            self.map{ |thing| thing.pick(*picks) }
          else
            picks.each_with_object({}) do |pick, result|

              if pick.kind_of? Hash

                pick.each do |attribute, nested_picks|
                  result[attribute] = self.__send__(attribute.to_sym).pick(*ensure_array[nested_picks])
                end

              else
                attribute = pick

                result[attribute] = self.__send__(attribute.to_sym)
              end

            end
          end
        end

      end
    end
  end
end