require 'minitest/autorun'
require 'augmented/objects/tappable'

describe Augmented::Objects::Tappable do
  using Augmented::Objects::Tappable

  describe '#tap_if' do

    it 'executes block if condition is truish' do
      subject = 'abc'
      test = nil

      subject.tap_if(true) { |subj| test = subj.upcase }

      assert_equal test, 'ABC'

      subject.tap_if(Object.new) { |subj| test = subj.reverse }

      assert_equal test, 'cba'
    end

    it 'does not execute block if condition is falsy' do
      subject = 'abc'
      test = nil

      subject.tap_if(false) { |subj| test = subj.upcase }

      assert_nil test

      subject.tap_if(nil) { |subj| test = subj.upcase }

      assert_nil test
    end

    it 'executes block if condition evaluates to truish' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 3 }
      condition_2 = -> subj { subj.length }

      subject.tap_if(condition_1) { |subj| test = subj.upcase }

      assert_equal test, 'ABC'

      subject.tap_if(condition_2) { |subj| test = subj.reverse }

      assert_equal test, 'cba'
    end

    it 'does not execute block if condition evaluates to falsy' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 0 }
      condition_2 = -> subj { nil }

      subject.tap_if(condition_1) { |subj| test = subj.upcase }

      assert_nil test

      subject.tap_if(condition_2) { |subj| test = subj.upcase }

      assert_nil test
    end

    it 'always returns the object' do
      subject = 'abc'

      assert_same subject.tap_if(true){}, subject
      assert_same subject.tap_if(false){}, subject
    end

  end

  describe '#tap_unless' do

    it 'executes block if condition is falsy' do
      subject = 'abc'
      test = nil

      subject.tap_unless(false) { |subj| test = subj.upcase }

      assert_equal test, 'ABC'

      subject.tap_unless(nil) { |subj| test = subj.reverse }

      assert_equal test, 'cba'
    end

    it 'does not execute block if condition is truish' do
      subject = 'abc'
      test = nil

      subject.tap_unless(true) { |subj| test = subj.upcase }

      assert_nil test

      subject.tap_unless(Object.new) { |subj| test = subj.upcase }

      assert_nil test
    end

    it 'executes block if condition evaluates to falsy' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 0 }
      condition_2 = -> subj { nil }

      subject.tap_unless(condition_1) { |subj| test = subj.upcase }

      assert_equal test, 'ABC'

      subject.tap_unless(condition_2) { |subj| test = subj.reverse }

      assert_equal test, 'cba'
    end

    it 'does not execute block if condition evaluates to truish' do
      subject = 'abc'
      test = nil
      condition_1 = -> subj { subj.length == 3 }
      condition_2 = -> subj { subj.length }

      subject.tap_unless(condition_1) { |subj| test = subj.upcase }

      assert_nil test

      subject.tap_unless(condition_2) { |subj| test = subj.upcase }

      assert_nil test
    end

    it 'always returns the object' do
      subject = 'abc'

      assert_same subject.tap_unless(true){}, subject
      assert_same subject.tap_unless(false){}, subject
    end

  end

end