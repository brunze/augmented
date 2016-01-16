require 'augmented/hashes/mappable'
require 'augmented/hashes/polymorphable'
require 'augmented/hashes/transformable'

module Augmented
  module Hashes
    include Mappable
    include Polymorphable
    include Transformable
  end
end