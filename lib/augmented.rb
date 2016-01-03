require 'augmented/version'

require 'augmented/arrays'
require 'augmented/hashes'
require 'augmented/objects'
require 'augmented/procs'
require 'augmented/symbols'

module Augmented
  include Arrays
  include Hashes
  include Objects
  include Procs
  include Symbols
end