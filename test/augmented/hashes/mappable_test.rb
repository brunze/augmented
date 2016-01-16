require 'minitest/autorun'
require 'augmented/hashes/mappable'

describe Augmented::Hashes::Mappable do
  using Augmented::Hashes::Mappable

  describe '#map_values' do

    it 'returns a new hash with the same keys but transformed values' do
      { aa: 11, bb: 22 }.map_values{ |i| i * 3 }.must_equal({ aa: 33, bb: 66 })
    end

  end

  describe '#map_keys' do

    it 'returns a new hash with the same values but transformed keys' do
      { aa: 11, bb: 22 }.map_keys{ |k| k.to_s[0] }.must_equal({ 'a' => 11, 'b' => 22 })
    end

  end

end