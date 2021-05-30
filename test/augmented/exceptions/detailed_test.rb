require 'minitest/autorun'
require 'augmented/exceptions/detailed'

describe Augmented::Exceptions::Detailed do
  using Augmented::Exceptions::Detailed

  describe '#detailed' do

    it 'returns the same exception but with the given details associated' do
      exception = RuntimeError.new('test').detailed({ foo: 10, bar: { baz: 30 } })
      assert_equal exception.details, { foo: 10, bar: { baz: 30 } }

      exception = RuntimeError.new('test').detailed(foo: 10, bar: { baz: 30 })
      assert_equal exception.details, { foo: 10, bar: { baz: 30 } }
    end

    it 'overwrites all details if the exception already had some' do
      exception = RuntimeError.new('test').detailed(foo: 10, bar: { baz: 30 })
      exception.details = { overwritten: true }

      assert_equal exception.details, { overwritten: true }
    end

  end

  describe '#details=' do

    it 'sets the details on the exception' do
      exception = RuntimeError.new('test')
      exception.details = { foo: 10, bar: { baz: 30 } }

      assert_equal exception.details, { foo: 10, bar: { baz: 30 } }
    end

    it 'overwrites all details if the exception already had some' do
      exception = RuntimeError.new('test')
      exception.details = { foo: 10, bar: { baz: 30 } }
      exception.details = { overwritten: true }

      assert_equal exception.details, { overwritten: true }
    end

  end

  describe '#details' do

    it 'returns the details of the exception' do
      exception = RuntimeError.new('test')
      exception.details = { foo: 10, bar: { baz: 30 } }

      assert_equal exception.details, { foo: 10, bar: { baz: 30 } }
    end

    it 'returns an empty hash if no details have ever been set on the exception' do
      exception = RuntimeError.new('test')

      assert_equal exception.details, {}
    end

  end

end