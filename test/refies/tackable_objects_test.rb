require 'minitest/autorun'

require_relative '../../lib/refies/tackable_objects'

describe Refies::TackableObjects do
  using Refies::TackableObjects

  describe '#tack' do

    it 'attaches new methods to an object' do
      obj = Object.new

      obj.tack lorem: 123, ipsum: -> { self }

      obj.lorem.must_equal 123
      obj.ipsum.object_id.must_equal obj.object_id
    end

  end

end