require 'minitest/autorun'
require 'augmented/arrays/indexable'

describe Augmented::Arrays::Indexable do
  using Augmented::Arrays::Indexable

  describe '#index_by' do

    it 'returns a hash keyed by the results of invoking the criterion on every array element and the values are the last element matching the criterion' do
      ['a', 'bbb', 'c', 'dd'].index_by(&:length).must_equal({ 1 => 'c', 2 => 'dd', 3 => 'bbb' })
    end

  end

end