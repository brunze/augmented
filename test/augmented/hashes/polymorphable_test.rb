require 'minitest/autorun'
require 'augmented/hashes/polymorphable'
require 'ostruct'

describe Augmented::Hashes::Polymorphable do
  using Augmented::Hashes::Polymorphable

  describe '#polymorph' do

    it 'returns an object of the class specified by the `:type` attribute, initialized with the hash itself' do
      object = { type: 'OpenStruct', speak: 'meeehh' }.polymorph

      assert_instance_of OpenStruct, object
      assert_equal object.speak, 'meeehh'
    end

    describe 'type attribute' do

      it 'can also be a string key in the hash' do
        assert_instance_of OpenStruct, { 'type' => 'OpenStruct' }.polymorph
      end

      it 'can be an arbitrary attribute in the hash' do
        assert_instance_of OpenStruct, { lorem_ipsum: 'OpenStruct' }.polymorph(:lorem_ipsum)
        assert_instance_of OpenStruct, { 'lorem_ipsum' => 'OpenStruct' }.polymorph(:lorem_ipsum)
      end

      it 'can be a class' do
        assert_instance_of OpenStruct, { type: OpenStruct }.polymorph()
      end

      it 'can be a class passed directly to the method, ignoring the type attribute in the hash' do
        assert_instance_of OpenStruct, { type: 'TotallyIgnoredClass' }.polymorph(OpenStruct)
      end

    end

    it 'raises an error if it cannot find a type class' do
      assert_raises(ArgumentError){ {}.polymorph }
      assert_raises(ArgumentError){ { type: nil }.polymorph }
    end

  end

end