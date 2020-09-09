require 'test_helper'

class InvokeCaseTest < Minitest::Test
  def setup
    @fruit = Fruit.new
    @formatter = Formatter.new('Hello, world!')
  end

  def test_it_will_change_instance_variable
    assert_nil @fruit.sweetness

    @fruit.invoke_case('watermelon')
    assert_equal 30, @fruit.sweetness

    @fruit.invoke_case('apple')
    assert_equal 17, @fruit.sweetness
  end

  def test_return_value
    assert_equal '<pdf>Hello, world!</pdf>', @formatter.invoke_case('pdf')
    assert_equal 'Hello, world!', @formatter.invoke_case('text')
    assert_equal '<p>Hello, world!</p>', @formatter.invoke_case('html')
  end

  def test_invalid_case
    error = assert_raises(RuntimeError){ @fruit.invoke_case('unknown') }
    assert_equal "Undefined case `unknown` for Fruit", error.message

    error = assert_raises(RuntimeError){ @formatter.invoke_case('html3.7') }
    assert_equal "Undefined case `html3.7` for Formatter", error.message
  end
end
