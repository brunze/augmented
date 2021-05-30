require 'augmented/version'

require 'augmented/arrays'
require 'augmented/enumerators'
require 'augmented/exceptions'
require 'augmented/hashes'
require 'augmented/modules'
require 'augmented/objects'
require 'augmented/procs'
require 'augmented/strings'
require 'augmented/symbols'

module Augmented
  include Arrays
  include Enumerators
  include Exceptions
  include Hashes
  include Modules
  include Objects
  include Procs
  include Strings
  include Symbols
end