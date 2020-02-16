# ElixirMiddlewareMemoryIssue

This project demonstrates how a process responsible only for routing RefC binaries around will hang onto references (ProcBins) to them, long after those references should have been GCed

## run it
mix run --no-halt

## Understanding what's logged


# TODO:
- be able to identify the lifecycle of the binary we are passing thought the middleware.
So far from the profiling it is not clear which binary it is. Or if it exhibits the lingering
behaviour we are trying to reproduce

### Asides/Minutiae
- the size of the binary reported by recon doesn't seem to correspond directly to the size of the binary sent from Sender. It caps out at ~4k. But i do think the binaries reported by recon are the binaries we send from Sender, because a change in size of the sent binary corresponds to a similar change in size in the binary reported by recon. And if you send a binary below 64 bytes, not binaries are reported to be referenced by the Middleware process, as we would expect
- If you don't log `data` in `receive/1` - namely if we don't actually _use_ the data we're sending through Middleware - Middleware will report no  binaries in its memory. Compiler optimization?
- If you pass Middleware the function you wish it to execute on the given data, the behaviour is the same. This set up, of function passing, was how we initially discovered this memory behaviour
