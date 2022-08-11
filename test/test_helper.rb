require 'simplecov'
SimpleCov.start 'test_frameworks'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'case_register'
require 'minitest/autorun'

def assert_before_and_after(test_proc, subject_proc, expected_value)
  before = test_proc.call
  subject_proc.call
  after = test_proc.call
  assert_equal expected_value, :before => before, :after => after
end

def expect_to_receive(obj, method, expected_args, return_value, &block)
  obj.stub(method, proc{|args|
    assert_equal(expected_args, args)
    next return_value
  }, &block)
end

def assert_frozen_error
  frozen_class = case
                 when Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2')   ; TypeError
                 when Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.5') ; RuntimeError
                 else                                                          ; FrozenError
                 end

  assert_raises(frozen_class){ yield }
end

class Fruit
  include CaseRegister

  attr_reader :sweetness

  register_case 'watermelon' do
    @sweetness = 30
  end

  register_case 'apple' do
    @sweetness = 17
  end
end

class Formatter
  include CaseRegister

  def initialize(text)
    @text = text
  end

  register_case('pdf'){ "<pdf>#{@text}</pdf>" }
  register_case('text'){ @text }
  register_case('html'){ "<p>#{@text}</p>" }
end
