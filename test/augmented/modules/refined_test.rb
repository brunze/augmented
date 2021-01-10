require 'minitest/autorun'
require 'augmented/modules/refined'

describe Augmented::Modules::Refined do
  using Augmented::Modules::Refined

  describe '#refined' do

    before do
      class TesterClass
        using refined String,
          as_phrase: -> { self.capitalize.gsub(/\.?\z/, '.') },
          fill:      -> filler { (filler * self.length)[0..length] }

        def do_test
          [
            'hello world'.as_phrase == 'Hello world.',
            'hello world'.fill('!') == '!!!!!!!!!!!',
          ]
        end
      end
    end

    it 'creates a refinement module on the fly for the given class, with the procs supplied' do
      assert_equal TesterClass.new.do_test, [true, true]
    end

  end
end
