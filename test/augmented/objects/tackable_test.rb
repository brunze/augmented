require 'minitest/autorun'
require 'augmented/objects/tackable'

describe Augmented::Objects::Tackable do
  using Augmented::Objects::Tackable

  describe '#tack' do

    it 'attaches a new singleton method to an object' do
      subject  = Object.new
      returned = subject.tack(forty_two: 42)

      assert_same  subject, returned
      assert_equal subject.forty_two, 42

      returned = subject.tack(:double) do
        forty_two * 2
      end

      assert_same  subject, returned
      assert_equal subject.double, 84

      returned = subject.tack(:add) do |other|
        forty_two + other
      end

      assert_same  subject, returned
      assert_equal subject.add(8), 50
    end

    it 'raises an error if passed a block but no valid method name' do
      assert_raises(ArgumentError){ Object.new.tack{ "nope!" } }
      assert_raises(ArgumentError){ Object.new.tack(nil){ "nope!" } }
      assert_raises(ArgumentError){ Object.new.tack(42){ "nope!" } }
    end

    it 'attaches many new singleton methods to an object at once' do
      subject = Object.new
      returned = subject.tack(
        forty_two: 42,
        double: -> { forty_two * 2},
        add: -> other { forty_two + other }
      )

      assert_equal subject.forty_two, 42
      assert_equal subject.double, 84
      assert_equal subject.add(8), 50
      assert_same  subject, returned
    end

  end

end