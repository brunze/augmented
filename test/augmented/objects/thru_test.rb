require 'minitest/autorun'
require 'augmented/objects/thru'

describe Augmented::Objects::Thru do
  using Augmented::Objects::Thru

  describe '#thru' do

    it 'returns the result of applying the given function to the object' do
      plus_10 = -> i { i + 10 }

      5.thru(&plus_10).must_equal 15
    end

  end

end