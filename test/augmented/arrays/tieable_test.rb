require 'minitest/autorun'
require 'augmented/arrays/tieable'

describe Augmented::Arrays::Tieable do
  using Augmented::Arrays::Tieable

  describe '#tie' do

    describe 'when supplied with an object' do

      it 'returns an array interweaved with the specified object' do
        object = Object.new
        weaved = %w(a b c).tie object

        assert_equal weaved, ['a', object, 'b', object, 'c']
      end

      it 'returns an empty array if the original array is empty' do
        assert_equal [].tie(1), []
      end

      it 'returns the original array if it has only one element' do
        assert_equal [42].tie(1), [42]
      end

    end

    describe 'when supplied with a block' do

      it 'returns an array interweaved with the result of invoking the block' do
        values = [10 ,20].each
        weaved = %w(a b c).tie{ values.next }

        assert_equal weaved, ['a', 10, 'b', 20, 'c']
      end

      it 'passes both neighbour values as arguments to the supplied block' do
        weaved = [1, 5, 12].tie{ |a, b| a + b }

        assert_equal weaved, [1, 6, 5, 17, 12]
      end

      it 'will weave nils if the block does not return anything else' do
        weaved = [1, 2, 3].tie{}

        assert_equal weaved, [1, nil, 2, nil, 3]
      end

      it 'returns an empty array if the original arrays is empty' do
        assert_equal [].tie{ 1 }, []
      end

      it 'returns the original array if it has only one element' do
        assert_equal [42].tie{ 1 }, [42]
      end

    end

    it 'raises an ArgumentError if not passed a non-nil object or block' do
      assert_raises(ArgumentError){ [].tie }
      assert_raises(ArgumentError){ [].tie nil }
    end

  end

end