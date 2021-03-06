require 'minitest/autorun'
require 'augmented/symbols/arguable'

describe Augmented::Symbols::Arguable do
  using Augmented::Symbols::Arguable

  describe '#with' do

    before do
      @eleven = Class.new do
        def add other_number
          11 + other_number
        end

        def add_many one_number, another_number, *many_numbers
          11 + one_number + another_number + many_numbers.reduce(0, :+)
        end

        def do_whatever
          yield 11
        end
      end.new
    end

    it 'returns a function that calls the method named <symbol> while also passing the arguments supplied' do
      assert_equal :add.with(9).call(@eleven), 20
      assert_equal :add_many.with(3, 6, 10, 20, 50).call(@eleven), 100
    end

    describe 'the returned function' do

      it "it preserves Symbol's `to_proc` behavior of passing extra arguments, if supplied" do
        assert_equal :add.to_proc.call(@eleven, 4), 15
        assert_equal :add.with().call(@eleven, 4), 15

        assert_equal :add_many.with(10, 20).call(@eleven, 4, 5), 50
      end

      it 'passes along the block supplied to `with`, if any' do
        result = nil
        set_result = -> i { result = i }

        :do_whatever.with(&set_result).call(@eleven)

        assert_equal result, 11
      end

    end

  end
end
