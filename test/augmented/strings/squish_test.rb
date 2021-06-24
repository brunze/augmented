require 'minitest/autorun'
require 'augmented/strings/squish'

describe Augmented::Strings::Squish do
  using Augmented::Strings::Squish

  describe '#squish' do

    describe 'using default parameters' do

      it 'returns a new stripped string with consecutive whitespace character runs replaced with a single space' do
        a = "  hello \t\n\r world  "

        assert_equal a.squish, 'hello world'
        assert_equal a, "  hello \t\n\r world  "
      end

    end

    describe 'using a custom pattern and replacement' do

      it 'return a new string with all pattern matches replaced except for matches at the edges of the string' do
        a = '42-abc:DEF!X$'

        assert_equal a.squish(/[^a-z]+/i, '__'), 'abc__DEF__X'
        assert_equal a, '42-abc:DEF!X$'
      end

    end

  end

  describe '#squish!' do

    describe 'using default parameters' do

      it 'strips the string and replaces consecutive whitespace character runs with a single space' do
        a = "  hello \t\n\r world  "

        assert_equal a.squish!, 'hello world'
        assert_equal a, 'hello world'
      end

    end

    describe 'using a custom pattern and replacement' do

      it 'replaces pattern matches with the given replacement except for matches at the edges of the string' do
        a = '42-abc:DEF!X$'

        assert_equal a.squish!(/[^a-z]+/i, '__'), 'abc__DEF__X'
        assert_equal a, 'abc__DEF__X'
      end

    end

  end

end