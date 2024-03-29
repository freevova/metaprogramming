defmodule MathTest do
  use Assertion

  test "integers can be added and subtracted" do
    assert 2 + 3 == 5
    assert 5 - 5 == 10
  end
  test "integers can be multiplied and divided" do
    assert 5 * 5 == 25
    assert 10 / 2 == 5
  end
end

# iex> MathTest.run
# .
# ===============================================
# FAILURE: integers can be added and subtracted
# ===============================================
# Expected: 0
# to be equal to: 10
