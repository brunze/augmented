require 'augmented/exceptions/chain'
require 'augmented/exceptions/detailed'
require 'augmented/exceptions/hashable'

module Augmented
  module Exceptions
    include Chain
    include Detailed
    include Hashable
  end
end