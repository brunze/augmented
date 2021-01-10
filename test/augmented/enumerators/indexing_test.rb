require 'minitest/autorun'
require 'augmented/enumerators/indexing'

describe Augmented::Enumerators::Indexing do
  using Augmented::Enumerators::Indexing

  describe '#index_by' do

    it 'returns a hash keyed by the results of invoking the criterion on every collection element and the values are the last element matching the criterion' do
      assert_equal ['a', 'bbb', 'c', 'dd'].to_enum.index_by(&:length), ({ 1 => 'c', 2 => 'dd', 3 => 'bbb' })
    end

  end

end