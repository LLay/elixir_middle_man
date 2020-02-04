# ElixirMiddlewareMemoryIssue

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_middleware_memory_issue` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_middleware_memory_issue, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir_middleware_memory_issue](https://hexdocs.pm/elixir_middleware_memory_issue).

TODO:
- be able to identify the lifecycle of the binary we are passing thought the middleware.
So far from the profiling it is not clear which binary it is. Or if it exhibits the lingering
behaviour we are trying to reproduce
