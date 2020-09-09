require 'test_helper'

class CaseRegisterTest < Minitest::Test
  def setup
  end

  def test_that_it_has_a_version_number
    refute_nil ::CaseRegister::VERSION
  end
end
