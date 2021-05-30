require 'minitest/autorun'
require 'augmented/exceptions/chain'

describe Augmented::Exceptions::Chain do
  using Augmented::Exceptions::Chain

  describe '#chain' do

    it 'returns an enumerator over the exception\'s causal chain, starting at the exception itself' do
      begin
        raise 'single'
      rescue => error
        assert_equal error.chain.map(&:message), %w(single)
      end

      begin
        begin
          begin
            raise 'first'
          rescue
            raise 'second'
          end
        rescue
          raise 'third'
        end
      rescue => error
        assert_equal error.chain.map(&:message), %w(third second first)
      end
    end

  end

end