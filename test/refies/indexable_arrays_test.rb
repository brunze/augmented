require 'minitest/autorun'

require_relative '../../lib/refies/indexable_arrays'

describe Refies::IndexableArrays do
  using Refies::IndexableArrays

  describe '#index_by' do

    it 'returns a hash keyed by the results of invoking the criterion on every array element and the values are the last element matching the criterion' do
      ['a', 'bbb', 'c', 'dd'].index_by(&:length).must_equal({ 1 => 'c', 2 => 'dd', 3 => 'bbb' })
    end

  end

end