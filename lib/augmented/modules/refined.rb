module Augmented
  module Modules
    module Refined
      refine Module do

        def refined klass, **hash_of_procs
          Module.new do
            refine klass do
              hash_of_procs.each_pair do |name, proc|
                define_method name, proc
              end
            end
          end
        end

      end
    end
  end
end