require 'test_helper'

class MayLoadRegisteredCaseTest < Minitest::Test
  def setup
    @fruit = Fruit.new
    @formatter = Formatter.new('Hello, world!')
  end

  def test_it_will_return_whether_the_case_is_defined
    assert_equal true, @fruit.may_load_registered_case?('watermelon')
    assert_equal true, @fruit.may_load_registered_case?('apple')
    assert_equal false, @fruit.may_load_registered_case?('apple2')

    assert_equal true, @formatter.may_load_registered_case?('pdf')
    assert_equal true, @formatter.may_load_registered_case?('html')
    assert_equal true, @formatter.may_load_registered_case?('text')
    assert_equal false, @formatter.may_load_registered_case?('html3.7')
  end
end
