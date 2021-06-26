require 'augmented/objects/iffy'
require 'augmented/objects/in'
require 'augmented/objects/pickable'
require 'augmented/objects/tackable'
require 'augmented/objects/tappable'
require 'augmented/objects/then_if'

module Augmented
  module Objects
    include Iffy
    include In
    include Pickable
    include Tackable
    include Tappable
    include ThenIf
  end
end