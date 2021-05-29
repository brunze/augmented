require 'minitest/autorun'
require 'augmented/strings/blank'

describe Augmented::Strings::Blank do
  using Augmented::Strings::Blank

  describe '#blank' do

    it 'returns true if the string is empty' do
      assert "".blank?
    end

    it 'returns true if the string is made only of whitespace characters' do
      assert " \n\r\t ".blank?
    end

    it 'returns false if the string contains at least one non-whitespace character' do
      refute "0".blank?
      refute " hello\nworld ".blank?
    end

  end

end