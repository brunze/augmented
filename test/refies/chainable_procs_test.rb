require 'minitest/autorun'

require_relative '../../lib/refies/chainable_procs'

describe Refies::ChainableProcs do
  using Refies::ChainableProcs

  describe '#|' do

    it 'returns a function that invokes from left to right' do

      add_one = -> (i) { i + 1 }
      triple = -> (i) { i * 3 }
      sub_two = -> (i) { i - 2 }
      add_twenty = -> (i) { i + 20 }

      chain = add_one | triple | sub_two | add_twenty

      chain.call(1).must_equal 24
    end

  end
end
