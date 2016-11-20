require 'minitest/autorun'
require 'augmented/procs/rescuable'

describe Augmented::Procs::Rescuable do
  using Augmented::Procs::Rescuable

  describe '#rescues' do

    it 'returns a proc which returns a provided value if the expected exception is raised' do
      specific_exception_class = Class.new RuntimeError

      unsafe_proc = -> { raise specific_exception_class }
      rescued_proc = unsafe_proc.rescues specific_exception_class, 42

      rescued_proc.call.must_equal 42
    end

    it 'returns a proc which returns the result of the provided block if the expected exception is raised' do
      specific_exception_class = Class.new RuntimeError

      unsafe_proc = -> { raise specific_exception_class }
      rescued_proc = unsafe_proc.rescues(specific_exception_class){ |exception| exception }

      rescued_proc.call.must_be_instance_of specific_exception_class
    end

    it 'returns a proc which lets exceptions other than the expected one to be raised' do
      specific_exception_class = Class.new RuntimeError

      unsafe_proc = -> { raise RuntimeError }
      rescued_proc = unsafe_proc.rescues specific_exception_class, 42

      rescued_proc.must_raise RuntimeError
    end

  end

end