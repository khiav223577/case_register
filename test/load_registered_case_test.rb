require 'test_helper'

class LoadRegisteredCaseTest < Minitest::Test
  def setup
    @fruit = Fruit.new
  end

  def test_it_will_change_instance_variable
    assert_equal nil, @fruit.sweetness

    @fruit.load_registered_case('watermelon')
    assert_equal 30, @fruit.sweetness

    @fruit.load_registered_case('apple')
    assert_equal 17, @fruit.sweetness
  end
end
