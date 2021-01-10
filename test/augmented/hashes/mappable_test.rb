require 'minitest/autorun'
require 'augmented/hashes/mappable'

describe Augmented::Hashes::Mappable do
  using Augmented::Hashes::Mappable

  describe '#map_values' do

    it 'returns a new hash with the same keys but transformed values' do
      assert_equal ({ aa: 11, bb: 22 }.map_values{ |i| i * 3 }), ({ aa: 33, bb: 66 })
    end

    it 'also provides the key and hash to the tranformer function as additional arguments' do
      hash = { aa: 11, bb: 22 }
      result = hash.map_values{ |i, key, h| [key, h.object_id] }

      assert_equal result.values, [[:aa, hash.object_id], [:bb, hash.object_id]]
    end

  end

  describe '#map_keys' do

    it 'returns a new hash with the same values but transformed keys' do
      assert_equal ({ aa: 11, bb: 22 }.map_keys{ |k| k.to_s[0] }), ({ 'a' => 11, 'b' => 22 })
    end

    it 'also provides the value and hash to the tranformer function as additional arguments' do
      hash = { aa: 11, bb: 22 }
      result = hash.map_keys{ |k, value, h| [value, h.object_id] }

      assert_equal result.keys, [[11, hash.object_id], [22, hash.object_id]]
    end

  end

end