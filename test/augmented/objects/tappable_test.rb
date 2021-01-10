require 'minitest/autorun'
require 'augmented/objects/tappable'

describe Augmented::Objects::Tappable do
  using Augmented::Objects::Tappable

  describe '#tap_if' do

    it 'executes block if condition is truish' do
      subject = 'abc'
      test = nil

      subject.tap_if(true) { |subj| test = subj.upcase }

      test.must_equal 'ABC'

      subject.tap_if(Object.new) { |subj| test = subj.reverse }

      test.must_equal 'cba'
    end

    it 'does not execute block if condition is falsy' do
      subject = 'abc'
      test = nil

      subject.tap_if(false) { |subj| test = subj.upcase }

      test.must_be_nil

      subject.tap_if(nil) { |subj| test = subj.upcase }

      test.must_be_nil
    end

    it 'executes block if condition evaluates to truish' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 3 }
      condition_2 = -> subj { subj.length }

      subject.tap_if(condition_1) { |subj| test = subj.upcase }

      test.must_equal 'ABC'

      subject.tap_if(condition_2) { |subj| test = subj.reverse }

      test.must_equal 'cba'
    end

    it 'does not execute block if condition evaluates to falsy' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 0 }
      condition_2 = -> subj { nil }

      subject.tap_if(condition_1) { |subj| test = subj.upcase }

      test.must_be_nil

      subject.tap_if(condition_2) { |subj| test = subj.upcase }

      test.must_be_nil
    end

    it 'always returns the object' do
      subject = 'abc'

      subject.tap_if(true){}.must_be_same_as subject
      subject.tap_if(false){}.must_be_same_as subject
    end

  end

  describe '#tap_unless' do

    it 'executes block if condition is falsy' do
      subject = 'abc'
      test = nil

      subject.tap_unless(false) { |subj| test = subj.upcase }

      test.must_equal 'ABC'

      subject.tap_unless(nil) { |subj| test = subj.reverse }

      test.must_equal 'cba'
    end

    it 'does not execute block if condition is truish' do
      subject = 'abc'
      test = nil

      subject.tap_unless(true) { |subj| test = subj.upcase }

      test.must_be_nil

      subject.tap_unless(Object.new) { |subj| test = subj.upcase }

      test.must_be_nil
    end

    it 'executes block if condition evaluates to falsy' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 0 }
      condition_2 = -> subj { nil }

      subject.tap_unless(condition_1) { |subj| test = subj.upcase }

      test.must_equal 'ABC'

      subject.tap_unless(condition_2) { |subj| test = subj.reverse }

      test.must_equal 'cba'
    end

    it 'does not execute block if condition evaluates to truish' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 3 }
      condition_2 = -> subj { subj.length }

      subject.tap_unless(condition_1) { |subj| test = subj.upcase }

      test.must_be_nil

      subject.tap_unless(condition_2) { |subj| test = subj.upcase }

      test.must_be_nil
    end

    it 'always returns the object' do
      subject = 'abc'

      subject.tap_unless(true){}.must_be_same_as subject
      subject.tap_unless(false){}.must_be_same_as subject
    end

  end

end