require 'minitest/autorun'

require_relative '../../lib/refies/thru_objects'

describe Refies::ThruObjects do
  using Refies::ThruObjects

  describe '#thru' do

    it 'returns the result of applying the given function to the object' do
      plus_10 = -> i { i + 10 }

      5.thru(&plus_10).must_equal 15
    end

  end

end