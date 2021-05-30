require 'augmented/exceptions/chain'
require 'augmented/exceptions/detailed'
require 'augmented/exceptions/serializable'

module Augmented
  module Exceptions
    include Chain
    include Detailed
    include Serializable
  end
end