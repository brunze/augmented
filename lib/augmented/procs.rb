require 'augmented/procs/chainable'
require 'augmented/procs/rescuable'

module Augmented
  module Procs
    include Chainable
    include Rescuable
  end
end
