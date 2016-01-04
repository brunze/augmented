require 'minitest/autorun'
require 'augmented/objects/thru'

describe Augmented::Objects::Thru do
  using Augmented::Objects::Thru

  describe '#thru' do

    it 'returns the result of applying the given function to the object' do
      plus_10 = -> i { i + 10 }

      5.thru(&plus_10).must_equal 15
    end

    it 'returns the object untouched if called without arguments' do
      obj = Object.new
      obj.thru.object_id.must_equal obj.object_id
    end

  end

end