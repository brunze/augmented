require 'minitest/autorun'
require 'augmented/objects/in'

describe Augmented::Objects::In do
  using Augmented::Objects::In

  describe '#in?' do

    it 'returns whether the object is included in the given collection' do
      assert 2.in?([1, 2, 3])
      assert 2.in?(1..2)
      assert :a.in?(Set.new(%i(a b c)))
      assert :a.in?({a: 1, b: 2, c: 3})
      assert 'C'.in?('ABC')

      refute 4.in?([1, 2, 3])
      refute 5.in?(1..2)
      refute :d.in?(Set.new(%i(a b c)))
      refute :d.in?({a: 1, b: 2, c: 3})
      refute 'D'.in?('ABC')
    end

  end

end