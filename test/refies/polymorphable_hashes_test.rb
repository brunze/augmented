require 'minitest/autorun'
require 'ostruct'

require_relative '../../lib/refies/polymorphable_hashes'

describe Refies::PolymorphableHashes do
  using Refies::PolymorphableHashes

  describe '#polymorph' do

    it 'returns an object of the class specified by the `:type` attribute, initialized with the hash itself' do
      object = { type: 'OpenStruct', speak: 'meeehh' }.polymorph

      object.must_be_instance_of OpenStruct
      object.speak.must_equal 'meeehh'
    end

    describe 'type attribute' do

      it 'can also be a string key in the hash' do
        { 'type' => 'OpenStruct' }.polymorph.must_be_instance_of OpenStruct
      end

      it 'can be an arbitrary attribute in the hash' do
        { lorem_ipsum: 'OpenStruct' }.polymorph(:lorem_ipsum).must_be_instance_of OpenStruct
        { 'lorem_ipsum' => 'OpenStruct' }.polymorph(:lorem_ipsum).must_be_instance_of OpenStruct
      end

      it 'can be a class' do
        { type: OpenStruct }.polymorph().must_be_instance_of OpenStruct
      end

      it 'can be a class passed directly to the method, ignoring the type attribute in the hash' do
        { type: 'TotallyIgnoredClass' }.polymorph(OpenStruct).must_be_instance_of OpenStruct
      end

    end

  end

end