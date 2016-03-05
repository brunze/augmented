require 'minitest/autorun'
require 'augmented/objects/iffy'

describe Augmented::Objects::Iffy do
  using Augmented::Objects::Iffy

  describe '#if' do

    it 'returns the object if the condition evaluates to truish' do
      subject = 'abc'
      condition = -> subj { subj.length == 3 }

      subject.if(true).must_be_same_as subject
      subject.if(Object.new).must_be_same_as subject
      subject.if(&condition).must_be_same_as subject
    end

    it 'returns nil if the condition evaluates to falsy' do
      subject = 'abc'
      condition = -> subj { subj.length == 0 }

      subject.if(false).must_be_same_as nil
      subject.if(nil).must_be_same_as nil
      subject.if(&condition).must_be_same_as nil
    end

  end

  describe '#else' do

    it 'returns the alternative if the object is falsy' do
      alternative = Object.new

      false.else(alternative).must_be_same_as alternative
      nil.else(alternative).must_be_same_as alternative
    end

    it 'returns the object if the object is truish' do
      subject = Object.new

      true.else(123).must_be_same_as true
      subject.else(123).must_be_same_as subject
    end

  end

end