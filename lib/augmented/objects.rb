require 'augmented/objects/pickable'
require 'augmented/objects/tackable'
require 'augmented/objects/tappable'
require 'augmented/objects/thru'

module Augmented
  module Objects
    include Pickable
    include Tackable
    include Tappable
    include Thru
  end
end