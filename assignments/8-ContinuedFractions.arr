# CSCI0190 (Fall 2018)
provide *
provide-types *

### IMPORTS BELOW

import shared-gdrive("contfracs-types.arr", "1YtBYBATzXGp4EwUYZlViFSPNZknv_Zgt")
as support
type Stream = support.Stream
lz-link = support.lz-link

### IMPORTS ABOVE

## Part 1: Streams

# cf-phi :: Stream<Number> = 
# cf-e :: Stream<Number> = 

fun nats-from(n :: Number) -> Stream<Number>:
  lz-link(n, {(): nats-from(n + 1)})
end

fun take<A>(s :: Stream<A>, n :: Number) -> List<A>:
  doc: "Takes the first n elements of a stream and returns them as a list"
  if n == 0:
    empty
  else:
    link(s.first, take(s.rest(), n - 1))
  end
where:
  rec ones = lz-link(1, {(): ones})
  nats = nats-from(0)
  take(ones, 5) is [list: 1, 1, 1, 1, 1]
  take(nats, 5) is [list: 0, 1, 2, 3, 4]
end

fun repeating-stream(numbers :: List<Number>) -> Stream<Number>:
  doc: ""
  ...
end

fun threshold(approximations :: Stream<Number>, thresh :: Number)-> Number:
  doc: ""
  ...
end

fun fraction-stream(coefficients :: Stream<Number>) -> Stream<Number>:
  doc: ""
  ...
end


## Part 2: Options and Terminating Streams

# cf-phi-opt :: Stream<Option<Number>> = 
# cf-e-opt :: Stream<Option<Number>> = 
# cf-pi-opt :: Stream<Option<Number>> = 

fun terminating-stream(numbers :: List<Number>) -> Stream<Option<Number>>:
  doc: ""
  ...
end

fun repeating-stream-opt(numbers :: List<Number>) -> Stream<Option<Number>>:
  doc: ""
  ...
end

fun threshold-opt(approximations :: Stream<Option<Number>>,
    thresh :: Number) -> Number:
  doc: ""
  ...
end

fun fraction-stream-opt(coefficients :: Stream<Option<Number>>)
  -> Stream<Option<Number>>:
  doc: ""
  ...
end
