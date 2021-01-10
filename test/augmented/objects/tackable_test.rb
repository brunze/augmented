require 'minitest/autorun'
require 'augmented/objects/tackable'

describe Augmented::Objects::Tackable do
  using Augmented::Objects::Tackable

  describe '#tack' do

    it 'attaches new methods to an object' do
      obj = Object.new

      obj.tack lorem: 123, ipsum: -> { self }

      assert_equal obj.lorem, 123
      assert_equal obj.ipsum.object_id, obj.object_id
    end

    it 'returns self' do
      obj = Object.new
      assert_equal obj.tack.object_id, obj.object_id
    end

  end

end