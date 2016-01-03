require 'minitest/autorun'
require 'augmented/hashes/transformable'
require 'ostruct'

describe Augmented::Hashes::Transformable do
  using Augmented::Hashes::Transformable

  describe '#transform(!)' do

    it 'mutates the values of the given keys by applying their respective procables' do
      hash = { thing1: 100, thing2: OpenStruct.new(random_method_name: 900) }.freeze

      new_hash = hash.transform thing1: -> i { i * 3 }, thing2: :random_method_name

      new_hash[:thing1].must_equal 300
      new_hash[:thing2].must_equal 900


      # mutable version test:
      hash = { thing1: 100, thing2: OpenStruct.new(random_method_name: 900) }

      hash.transform! thing1: -> i { i * 3 }, thing2: :random_method_name

      hash[:thing1].must_equal 300
      hash[:thing2].must_equal 900
    end

    it 'applies procables recursively when given a hash' do
      hash = { a: { b: { c: 100 } } }.freeze

      new_hash = hash.transform({ a: { b: { c: -> i { i * 3 } } } })

      new_hash[:a][:b][:c].must_equal 300


      # mutable version test:
      hash = { a: { b: { c: 100 } } }

      hash.transform!({ a: { b: { c: -> i { i * 3 } } } })

      hash[:a][:b][:c].must_equal 300
    end

    it 'applies procables to all elements of a collection if a value is iterable (iterable MUST be a collection of hashes)' do
      hash = { a: [ { my_value: 10 }, { my_value: 20 } ] }.freeze

      new_hash = hash.transform(a: { my_value: -> i { i * 3 } })

      new_hash[:a].must_equal [ { my_value: 30 }, { my_value: 60 } ]


      # mutable version test:
      hash = { a: [ { my_value: 10 }, { my_value: 20 } ] }

      hash.transform!(a: { my_value: -> i { i * 3 } })

      hash[:a].must_equal [ { my_value: 30 }, { my_value: 60 } ]
    end

    it 'can apply several procables to a value, supplied in an array, executed from left to right' do
      add_ten = -> i { i + 10 }
      double = -> i { i * 2 }

      hash = { a: 2.5 }.freeze

      new_hash = hash.transform a: [ :to_i, add_ten, double ]

      new_hash[:a].must_equal 24


      # mutable version test:
      hash = { a: 2.5 }

      hash.transform! a: [ :to_i, add_ten, double ]

      hash[:a].must_equal 24
    end

    it 'returns itself (mutable version only)' do
      hash = {}
      same_hash = hash.transform! Hash.new

      same_hash.object_id.must_equal hash.object_id
    end

  end
end
