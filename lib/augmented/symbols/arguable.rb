module Augmented
  module Symbols
    module Arguable
      refine Symbol do

        # credit to Uri Agassi: http://stackoverflow.com/a/23711606/2792897
        def with *args, &block
          -> caller, *rest { caller.__send__ self, *rest, *args, &block }
        end

      end
    end
  end
end