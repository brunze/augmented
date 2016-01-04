require 'augmented/version'

require 'augmented/enumerators'
require 'augmented/hashes'
require 'augmented/objects'
require 'augmented/procs'
require 'augmented/symbols'

module Augmented
  include Enumerators
  include Hashes
  include Objects
  include Procs
  include Symbols
end