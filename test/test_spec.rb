require_relative 'helper'

class TestSpec < Minitest::Test
  def setup
    @spec = Spec.new
  end

  def test_constructor
    assert_equal({}, @spec.instance_variable_get(:@tree))
  end
end
