# ElixirMiddlewareMemoryIssue

This project demonstrates how a process that is responsible only for routing RefC binaries to other processes will hang onto references (ProcBins) to these binaries, long after those references should have been garbage collected.

## Run it
```
mix run --no-halt
```

## Explanation

This app spins up 3 processes: Sender, Middleware, and Profiler.
Sender simply sends a Refc binary (`data`) through Middleware to itself, and logs it.
It does this every 300ms.
Profiler runs every 100ms and prints out information about the Middleware's heap and the number of
minor garbage collections the process has completed since the last full sweep.

Here's the entry point: [lib/sender.ex:19](lib/sender.ex:19)

The Profiler uses [Recon](https://ferd.github.io/recon/recon.html) and logs a message that look like this:
```
17:37:02.087 [info]  Middleware process info:
      binary: [{359929968, 336, 1}, {359937112, 365, 3}],
      num_minor_gcs: 8
```
`binary` is of the form [{BinaryId, BinarySize, BinaryRefcCount}, ...].

`num_minor_gcs` tells us when a fullsweep has occurred by dropping back 0.

Official docs are here http://erlang.org/doc/man/erlang.html#process_info-1 @ "{binary, BinInfo}"
I'm using a production safe version wrapper of this function, documented here: https://ferd.github.io/recon/recon.html#info-1
To learn more about garbage collection the [BEAM Book](https://blog.stenmans.org/theBeamBook/#_the_garbage_collector_gc)
is a good place to start, or you can refer to some of the references listed below.

When we run the app, the profiling shows that the Middleware's heap
contains ProcBin binary references that persist through repeated fullsweep
garbage collections. Since the binaries at play are just logged, with no
persistent references to them (such as you might see [when storing data in an ets table](https://medium.com/@tylerpachal/tracking-down-an-ets-related-memory-leak-a115a4499a2f)), we don't expect them to stick around. But they do.
[profiling.log](profiling.log) shows an example of a run of this application.
You can see from the logs that the binary with the id `359929968` remains on
the Middleware's heap across many full sweeps. Note that not every run of the
application reproduces this behaviour.

There a ton of information you can pull from `:erlang.process_info(pid)` or
`:recon.info(pid)` if you feel like doing some more digging into what going on.

## Asides/Minutiae
- The size of the binary reported by recon doesn't seem to correspond directly to the size of the binary sent from Sender. It caps out at ~4k. But I do think the binaries reported by recon are the binaries we send from Sender, because a change in size of the sent binary corresponds to a similar change in size in the binary reported by recon. And if you send a binary below 64 bytes, no binaries are reported to be referenced by the Middleware process, as we would expect.
- If you don't log `data` in `Sender.receive/1` - namely if we don't actually _use_ the data we're sending through Middleware - Middleware will report no  binaries in its memory. This seems likely to be a compiler optimization.
- If you pass Middleware the function you wish it to execute on the given data, the behaviour is the same. This set up, of function passing, was how we initially discovered this memory behaviour

## References

##### General
- https://blog.stenmans.org/theBeamBook
- https://www.erlang-in-anger.com/

##### Binaries
- https://erlang.org/doc/efficiency_guide/binaryhandling.html#how-binaries-are-implemented

##### Garbage Collecting
- https://www.erlang-solutions.com/blog/erlang-garbage-collector.html
- https://hamidreza-s.github.io/erlang%20garbage%20collection%20memory%20layout%20soft%20realtime/2015/08/24/erlang-garbage-collection-details-and-why-it-matters.html
