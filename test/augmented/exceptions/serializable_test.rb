require 'minitest/autorun'
require 'augmented/exceptions/serializable'

describe Augmented::Exceptions::Serializable do
  using Augmented::Exceptions::Serializable
  using Augmented::Exceptions::Detailed

  describe '#to_h' do

    it 'serializes the exception into a Hash including its details and causal chain' do
      error = begin
        raise ArgumentError.new('test message').detailed(lorem: 'ipsum')
      rescue => error
        error
      end

      hash = error.to_h
      assert_equal hash[:class], 'ArgumentError'
      assert_equal hash[:message], 'test message'
      assert_equal hash[:details], { lorem: 'ipsum' }
      assert       hash[:backtrace].any?
      assert_nil   hash[:cause]

      error = begin
        begin
          begin
            raise RuntimeError.new('first').detailed(aa: 10)
          rescue
            raise RuntimeError.new('second')
          end
        rescue
          raise RuntimeError.new('third').detailed(cc: 30)
        end
      rescue => error
        error
      end

      hash = error.to_h
      assert_equal hash[:class], 'RuntimeError'
      assert_equal hash[:message], 'third'
      assert_equal hash[:details], { cc: 30 }
      assert       hash[:backtrace].any?
      assert_equal hash[:cause][:class], 'RuntimeError'
      assert_equal hash[:cause][:message], 'second'
      assert_equal hash[:cause][:details], {}
      assert       hash[:cause][:backtrace].any?
      assert_equal hash[:cause][:cause][:class], 'RuntimeError'
      assert_equal hash[:cause][:cause][:message], 'first'
      assert_equal hash[:cause][:cause][:details], { aa: 10 }
      assert       hash[:cause][:cause][:backtrace].any?
      assert_nil   hash[:cause][:cause][:cause]
    end

  end

end