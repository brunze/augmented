require 'augmented/strings/blank'
require 'augmented/strings/squish'
require 'augmented/strings/truncatable'

module Augmented
  module Strings
    include Blank
    include Squish
    include Truncatable
  end
end