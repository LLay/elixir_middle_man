defmodule ElixirMiddlewareMemoryIssueTest do
  use ExUnit.Case
  doctest ElixirMiddlewareMemoryIssue

  test "greets the world" do
    assert ElixirMiddlewareMemoryIssue.hello() == :world
  end
end
