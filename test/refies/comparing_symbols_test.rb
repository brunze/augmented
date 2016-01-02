require 'minitest/autorun'

require_relative '../../lib/refies/comparing_symbols'

describe Refies::ComparingSymbols do
  using Refies::ComparingSymbols

  let(:dummy) { Struct.new :lorem_ipsum }

  let(:thing_A) { dummy.new 123 }
  let(:thing_B) { dummy.new 123 }
  let(:thing_C) { dummy.new 987 }
  let(:thing_D) { dummy.new 0 }

  describe '#eq' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `==`' do
      comparator = :lorem_ipsum.eq

      comparator.call(thing_A, thing_B).must_equal true
      comparator.call(thing_A, thing_C).must_equal false
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `==`' do
      comparator = :lorem_ipsum.eq(123)

      comparator.call(thing_A).must_equal true
      comparator.call(thing_C).must_equal false
    end

  end

  describe '#neq' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `!=`' do
      comparator = :lorem_ipsum.neq

      comparator.call(thing_A, thing_B).must_equal false
      comparator.call(thing_A, thing_C).must_equal true
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `!=`' do
      comparator = :lorem_ipsum.neq(123)

      comparator.call(thing_A).must_equal false
      comparator.call(thing_C).must_equal true
    end

  end

  describe '#lt' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `<`' do
      comparator = :lorem_ipsum.lt

      comparator.call(thing_A, thing_B).must_equal false
      comparator.call(thing_A, thing_C).must_equal true
      comparator.call(thing_C, thing_B).must_equal false
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `<`' do
      comparator = :lorem_ipsum.lt(123)

      comparator.call(thing_A).must_equal false
      comparator.call(thing_C).must_equal false
      comparator.call(thing_D).must_equal true
    end

  end

  describe '#lte' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `<=`' do
      comparator = :lorem_ipsum.lte

      comparator.call(thing_A, thing_B).must_equal true
      comparator.call(thing_A, thing_C).must_equal true
      comparator.call(thing_C, thing_B).must_equal false
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `<=`' do
      comparator = :lorem_ipsum.lte(123)

      comparator.call(thing_A).must_equal true
      comparator.call(thing_C).must_equal false
      comparator.call(thing_D).must_equal true
    end

  end

  describe '#gt' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `>`' do
      comparator = :lorem_ipsum.gt

      comparator.call(thing_A, thing_B).must_equal false
      comparator.call(thing_A, thing_C).must_equal false
      comparator.call(thing_C, thing_B).must_equal true
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `>`' do
      comparator = :lorem_ipsum.gt(123)

      comparator.call(thing_A).must_equal false
      comparator.call(thing_C).must_equal true
      comparator.call(thing_D).must_equal false
    end

  end

  describe '#gte' do

    it 'returns a function that sends <symbol> to two objects and compares the results with `>=`' do
      comparator = :lorem_ipsum.gte

      comparator.call(thing_A, thing_B).must_equal true
      comparator.call(thing_A, thing_C).must_equal false
      comparator.call(thing_C, thing_B).must_equal true
    end

    it 'if you give it a value, it returns a function that sends <symbol> to an object and compares the result to a given value using `>=`' do
      comparator = :lorem_ipsum.gte(123)

      comparator.call(thing_A).must_equal true
      comparator.call(thing_C).must_equal true
      comparator.call(thing_D).must_equal false
    end

  end


end
