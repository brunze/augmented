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

  describe '#thru_if' do

    it 'applies the given function to the object if the condition is truish' do
      plus_10 = -> i { i + 10 }

      5.thru_if(true, &plus_10).must_equal 15
      5.thru_if(Object.new, &plus_10).must_equal 15
    end

    it 'applies the given function to the object if the condition evaluates to truish' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 5 }
      condition_2 = -> i { i.to_s }

      5.thru_if(condition_1, &plus_10).must_equal 15
      5.thru_if(condition_2, &plus_10).must_equal 15
    end

    it 'returns the object without applying the function if the condition is falsy' do
      plus_10 = -> i { i + 10 }

      5.thru_if(false, &plus_10).must_equal 5
      5.thru_if(nil,   &plus_10).must_equal 5
    end

    it 'returns the object without applying the function if the condition evaluates to falsy' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 10 }
      condition_2 = -> i { nil }

      5.thru_if(condition_1, &plus_10).must_equal 5
      5.thru_if(condition_2, &plus_10).must_equal 5
    end

  end

  describe '#thru_unless' do

    it 'applies the given function to the object if the condition is falsy' do
      plus_10 = -> i { i + 10 }

      5.thru_unless(false, &plus_10).must_equal 15
      5.thru_unless(nil,   &plus_10).must_equal 15
    end

    it 'applies the given function to the object if the condition evaluates to falsy' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 10 }
      condition_2 = -> i { nil }

      5.thru_unless(condition_1, &plus_10).must_equal 15
      5.thru_unless(condition_2, &plus_10).must_equal 15
    end

    it 'returns the object without applying the function if the condition is truish' do
      plus_10 = -> i { i + 10 }

      5.thru_unless(true, &plus_10).must_equal 5
      5.thru_unless(Object.new, &plus_10).must_equal 5
    end

    it 'returns the object without applying the function if the condition evaluates to truish' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 5 }
      condition_2 = -> i { i.to_s }

      5.thru_unless(condition_1, &plus_10).must_equal 5
      5.thru_unless(condition_2, &plus_10).must_equal 5
    end

  end

end