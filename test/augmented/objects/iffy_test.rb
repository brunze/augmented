require 'minitest/autorun'
require 'augmented/objects/iffy'

describe Augmented::Objects::Iffy do
  using Augmented::Objects::Iffy

  describe '#if' do

    it 'returns the object if the condition evaluates to truish' do
      subject = 'abc'
      condition = -> subj { subj.length == 3 }

      assert_same subject.if(true), subject
      assert_same subject.if(Object.new), subject
      assert_same subject.if(&condition), subject
    end

    it 'returns nil if the condition evaluates to falsy' do
      subject = 'abc'
      condition = -> subj { subj.length == 0 }

      assert_nil subject.if(false)
      assert_nil subject.if(nil)
      assert_nil subject.if(&condition)
    end

  end

  describe '#unless' do

    it 'returns the object if the condition evaluates to falsy' do
      subject = 'abc'
      condition = -> subj { subj.length == 0 }

      assert_same subject.unless(false), subject
      assert_same subject.unless(nil), subject
      assert_same subject.unless(&condition), subject
    end

    it 'returns nil if the condition evaluates to truish' do
      subject = 'abc'
      condition = -> subj { subj.length == 3 }

      assert_nil subject.unless(true)
      assert_nil subject.unless(Object.new)
      assert_nil subject.unless(&condition)
    end

  end

  describe '#else' do

    it 'returns the alternative if the object is falsy' do
      alternative = Object.new

      assert_same false.else(alternative), alternative
      assert_same nil.else(alternative), alternative
    end

    it 'returns the object if the object is truish' do
      subject = Object.new

      assert_same true.else(123), true
      assert_same subject.else(123), subject
    end

  end

end