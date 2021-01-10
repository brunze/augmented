require 'minitest/autorun'
require 'augmented/procs/chainable'

describe Augmented::Procs::Chainable do
  using Augmented::Procs::Chainable

  describe '#|' do

    it 'returns a function that invokes from left to right' do

      add_one = -> (i) { i + 1 }
      triple = -> (i) { i * 3 }
      sub_two = -> (i) { i - 2 }
      add_twenty = -> (i) { i + 20 }

      chain = add_one | triple | sub_two | add_twenty

      assert_equal chain.call(1), 24
    end

  end
end
