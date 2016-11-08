require 'augmented/version'

require 'augmented/arrays'
require 'augmented/enumerators'
require 'augmented/hashes'
require 'augmented/modules'
require 'augmented/objects'
require 'augmented/procs'
require 'augmented/symbols'

module Augmented
  include Arrays
  include Enumerators
  include Hashes
  include Modules
  include Objects
  include Procs
  include Symbols
end