module Augmented
  module Strings
    module Squish
      refine String do

        def squish pattern = /\s+/, replacement = ' '
          dup.squish!(pattern, replacement)
        end

        def squish! pattern = /\s+/, replacement = ' '
          cursor = 0

          while match = pattern.match(self, cursor)
            slice_start  = match.begin(0)
            slice_end    = match.end(0)
            slice_length = slice_end - slice_start

            slice!(slice_start, slice_length)

            if slice_start == 0
              # we're at the start of the string
              # don't insert the replacement
              # don't change the cursor
            elsif slice_end >= self.size
              # we're at the end of the string
              # don't insert the replacement
              break
            else
              insert(slice_start, replacement)
              cursor = slice_start + replacement.size
            end
          end

          self
        end

      end
    end
  end
end