require 'test_helper'

class LoadRegisteredCaseTest < Minitest::Test
  def setup
    @fruit = Fruit.new
    @formatter = Formatter.new('Hello, world!')
  end

  def test_it_will_change_instance_variable
    assert_nil @fruit.sweetness

    @fruit.load_registered_case('watermelon')
    assert_equal 30, @fruit.sweetness

    @fruit.load_registered_case('apple')
    assert_equal 17, @fruit.sweetness
  end

  def test_return_value
    assert_equal '<pdf>Hello, world!</pdf>', @formatter.load_registered_case('pdf')
    assert_equal 'Hello, world!', @formatter.load_registered_case('text')
    assert_equal '<p>Hello, world!</p>', @formatter.load_registered_case('html')
  end

  def test_invalid_case
    error = assert_raises(RuntimeError){ @fruit.load_registered_case('unknown') }
    assert_equal "Undefined case `unknown` for Fruit", error.message

    error = assert_raises(RuntimeError){ @formatter.load_registered_case('html3.7') }
    assert_equal "Undefined case `html3.7` for Formatter", error.message
  end
end
