require 'minitest/autorun'
require 'augmented/strings/truncatable'

describe Augmented::Strings::Truncatable do
  using Augmented::Strings::Truncatable

  describe '#truncate' do

    it 'returns a prefix of the string up to the given number of characters' do
      assert_equal 'abcdef'.truncate(4), 'abcd'
      assert_equal 'çãõ'.truncate(1), 'ç'
    end

    it 'returns the whole string if it is shorter than the requested number of characters' do
      assert_equal 'abcdef'.truncate(10), 'abcdef'
    end

    it 'returns an empty string if given a length of 0' do
      assert_equal 'abcdef'.truncate(0), ''
    end

    it 'returns an empty string if the target string is empty' do
      assert_equal ''.truncate(10), ''
    end

    it 'raises an error if given nothing or a negative number' do
      assert_raises(ArgumentError){ ''.truncate()    }
      assert_raises(ArgumentError){ ''.truncate(nil) }
      assert_raises(ArgumentError){ ''.truncate(-1)  }
    end

  end

  describe '#truncate!' do

    it 'trims the string up to the given number of characters and returns the resulting string' do
      string = 'abcdef'
      result = string.truncate!(4)

      assert_equal string, 'abcd'
      assert_equal result, 'abcd'

      string = 'çãõ'
      result = string.truncate!(1)

      assert_equal string, 'ç'
      assert_equal result, 'ç'
    end

    it 'returns the unmodified string if it is shorter than the requested number of characters' do
      string = 'abcdef'
      result = string.truncate!(10)

      assert_equal string, 'abcdef'
      assert_equal result, 'abcdef'
    end

    it 'returns an empty string if given a length of 0' do
      string = 'abcdef'
      result = string.truncate!(0)

      assert_equal string, ''
      assert_equal result, ''
    end

    it 'returns an empty string if the target string is empty' do
      string = ''
      result = string.truncate!(10)

      assert_equal string, ''
      assert_equal result, ''
    end

    it 'raises an error if given nothing or a negative number' do
      assert_raises(ArgumentError){ ''.truncate!()    }
      assert_raises(ArgumentError){ ''.truncate!(nil) }
      assert_raises(ArgumentError){ ''.truncate!(-1)  }
    end

  end

end