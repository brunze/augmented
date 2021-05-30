require 'augmented/exceptions/chain'
require 'augmented/exceptions/detailed'

module Augmented
  module Exceptions
    include Chain
    include Detailed
  end
end