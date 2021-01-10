require 'minitest/autorun'
require 'augmented/symbols/comparing'

describe Augmented::Symbols::Comparing do
  using Augmented::Symbols::Comparing

  let(:dummy) { Struct.new :lorem_ipsum }

  let(:thing_A) { dummy.new 123 }
  let(:thing_B) { dummy.new 123 }
  let(:thing_C) { dummy.new 987 }
  let(:thing_D) { dummy.new 0 }

  describe '#eq' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `==`' do
      comparator = :lorem_ipsum.eq

      assert_equal comparator.call(thing_A, thing_B), true
      assert_equal comparator.call(thing_A, thing_C), false
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `==`' do
      comparator = :lorem_ipsum.eq(123)

      assert_equal comparator.call(thing_A), true
      assert_equal comparator.call(thing_C), false
    end

  end

  describe '#neq' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `!=`' do
      comparator = :lorem_ipsum.neq

      assert_equal comparator.call(thing_A, thing_B), false
      assert_equal comparator.call(thing_A, thing_C), true
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `!=`' do
      comparator = :lorem_ipsum.neq(123)

      assert_equal comparator.call(thing_A), false
      assert_equal comparator.call(thing_C), true
    end

  end

  describe '#lt' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `<`' do
      comparator = :lorem_ipsum.lt

      assert_equal comparator.call(thing_A, thing_B), false
      assert_equal comparator.call(thing_A, thing_C), true
      assert_equal comparator.call(thing_C, thing_B), false
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `<`' do
      comparator = :lorem_ipsum.lt(123)

      assert_equal comparator.call(thing_A), false
      assert_equal comparator.call(thing_C), false
      assert_equal comparator.call(thing_D), true
    end

  end

  describe '#lte' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `<=`' do
      comparator = :lorem_ipsum.lte

      assert_equal comparator.call(thing_A, thing_B), true
      assert_equal comparator.call(thing_A, thing_C), true
      assert_equal comparator.call(thing_C, thing_B), false
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `<=`' do
      comparator = :lorem_ipsum.lte(123)

      assert_equal comparator.call(thing_A), true
      assert_equal comparator.call(thing_C), false
      assert_equal comparator.call(thing_D), true
    end

  end

  describe '#gt' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `>`' do
      comparator = :lorem_ipsum.gt

      assert_equal comparator.call(thing_A, thing_B), false
      assert_equal comparator.call(thing_A, thing_C), false
      assert_equal comparator.call(thing_C, thing_B), true
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `>`' do
      comparator = :lorem_ipsum.gt(123)

      assert_equal comparator.call(thing_A), false
      assert_equal comparator.call(thing_C), true
      assert_equal comparator.call(thing_D), false
    end

  end

  describe '#gte' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `>=`' do
      comparator = :lorem_ipsum.gte

      assert_equal comparator.call(thing_A, thing_B), true
      assert_equal comparator.call(thing_A, thing_C), false
      assert_equal comparator.call(thing_C, thing_B), true
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `>=`' do
      comparator = :lorem_ipsum.gte(123)

      assert_equal comparator.call(thing_A), true
      assert_equal comparator.call(thing_C), true
      assert_equal comparator.call(thing_D), false
    end

  end


end
