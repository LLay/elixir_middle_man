# ElixirMiddlewareMemoryIssue

This project demonstrates how a process responsible only for routing RefC binaries around will hang onto references (ProcBins) to them, long after those references should have been GCed

## run it
mix run --no-halt

# TODO:
- be able to identify the lifecycle of the binary we are passing thought the middleware.
So far from the profiling it is not clear which binary it is. Or if it exhibits the lingering
behaviour we are trying to reproduce
- profile no
