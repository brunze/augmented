require 'minitest/autorun'
require 'augmented/exceptions/hashable'

describe Augmented::Exceptions::Hashable do
  using Augmented::Exceptions::Hashable
  using Augmented::Exceptions::Detailed

  describe '#to_h' do

    it 'serializes the exception into a Hash including its details and causal chain' do
      begin
        raise ArgumentError.new('test message').detailed(lorem: 'ipsum')
      rescue => error
        assert_equal error.to_h, {
          class: 'ArgumentError',
          message: 'test message',
          details: { lorem: 'ipsum' },
          cause: nil,
        }
      end

      begin
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
        assert_equal error.to_h, {
          class: 'RuntimeError',
          message: 'third',
          details: { cc: 30 },
          cause: {
            class: 'RuntimeError',
            message: 'second',
            details: {},
            cause: {
              class: 'RuntimeError',
              message: 'first',
              details: { aa: 10 },
              cause: nil,
            }
          }
        }
      end
    end

  end

end