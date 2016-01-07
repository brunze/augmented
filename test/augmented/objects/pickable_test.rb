require 'minitest/autorun'
require 'augmented/objects/pickable'
require 'ostruct'

describe Augmented::Objects::Pickable do
  using Augmented::Objects::Pickable

  describe '#pick' do

    it 'returns a hash with the results of invoking the list of picks in the target' do
      target = OpenStruct.new aaa: 111, bbb: 222, ccc: 333

      target.pick(:aaa, :ccc).must_equal({ aaa: 111, ccc: 333 })
    end

    it 'returns the result of invoking `pick` on every element of an enumerable target' do
      target = [ OpenStruct.new(val: 11), OpenStruct.new(val: 22), OpenStruct.new(val: 33) ]

      target.pick(:val).must_equal [{val: 11}, {val: 22}, {val: 33}]
    end

    it 'applies picks recursively when provided with hashes' do
      target = OpenStruct.new(aa: (OpenStruct.new bb: (OpenStruct.new cc: 33)))

      target.pick(aa: { bb: :cc }).must_equal({ aa: { bb: { cc: 33 } } })

      target = OpenStruct.new(dd: OpenStruct.new(ee: 55), ff: OpenStruct.new(gg: 77))

      target.pick(dd: :ee, ff: :gg).must_equal({ dd: { ee: 55 }, ff: { gg: 77 } })
    end

    it 'allows you to specify pick lists with arrays when picking recursively' do
      target = OpenStruct.new aa: (OpenStruct.new bb: 22, cc: (OpenStruct.new dd: 44, ee: 55))

      target.pick(aa: [:bb, cc: [:dd, :ee]]).must_equal({ aa: { bb: 22, cc: { dd: 44, ee: 55 } } })
    end

  end
end