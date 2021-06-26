require 'minitest/autorun'
require 'augmented/objects/then_if'

describe Augmented::Objects::ThenIf do
  using Augmented::Objects::ThenIf

  describe '#then_if' do

    it 'applies the given function to the object if the condition is truish' do
      plus_10 = -> i { i + 10 }

      assert_equal 5.then_if(true, &plus_10), 15
      assert_equal 5.then_if(Object.new, &plus_10), 15
    end

    it 'applies the given function to the object if the condition evaluates to truish' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 5 }
      condition_2 = -> i { i.to_s }

      assert_equal 5.then_if(condition_1, &plus_10), 15
      assert_equal 5.then_if(condition_2, &plus_10), 15
    end

    it 'returns the object without applying the function if the condition is falsy' do
      plus_10 = -> i { i + 10 }

      assert_equal 5.then_if(false, &plus_10), 5
      assert_equal 5.then_if(nil,   &plus_10), 5
    end

    it 'returns the object without applying the function if the condition evaluates to falsy' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 10 }
      condition_2 = -> i { nil }

      assert_equal 5.then_if(condition_1, &plus_10), 5
      assert_equal 5.then_if(condition_2, &plus_10), 5
    end

  end

  describe '#then_unless' do

    it 'applies the given function to the object if the condition is falsy' do
      plus_10 = -> i { i + 10 }

      assert_equal 5.then_unless(false, &plus_10), 15
      assert_equal 5.then_unless(nil,   &plus_10), 15
    end

    it 'applies the given function to the object if the condition evaluates to falsy' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 10 }
      condition_2 = -> i { nil }

      assert_equal 5.then_unless(condition_1, &plus_10), 15
      assert_equal 5.then_unless(condition_2, &plus_10), 15
    end

    it 'returns the object without applying the function if the condition is truish' do
      plus_10 = -> i { i + 10 }

      assert_equal 5.then_unless(true, &plus_10), 5
      assert_equal 5.then_unless(Object.new, &plus_10), 5
    end

    it 'returns the object without applying the function if the condition evaluates to truish' do
      plus_10 = -> i { i + 10 }

      condition_1 = -> i { i == 5 }
      condition_2 = -> i { i.to_s }

      assert_equal 5.then_unless(condition_1, &plus_10), 5
      assert_equal 5.then_unless(condition_2, &plus_10), 5
    end

  end

end