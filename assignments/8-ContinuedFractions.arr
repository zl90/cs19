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

fun repeating-stream-builder<A>(lst :: List<A>, s :: Stream<A>) -> Stream<A>:
  cases (List) lst:
    | empty => lz-link(s.first, {(): s.rest()})
    | link(f, r) =>
      lz-link(f, {(): repeating-stream-builder(r, s)})
  end
end

fun repeating-stream(numbers :: List<Number>) -> Stream<Number>:
  doc: "Given a list, produces a stream that repeats the list over and over"
  rec result = lz-link(numbers.first, {(): repeating-stream-builder(numbers.rest, result)})
  result
where:
  take(repeating-stream([list: 1, 2, 3]), 8) is [list: 1, 2, 3, 1, 2, 3, 1, 2]
end

cf-phi :: Stream<Number> = repeating-stream([list: 1])
cf-e :: Stream<Number> = repeating-stream([list: 2, 1, 2, 1, 1, 4, 1, 1, 6, 1, 1])

fun threshold(approximations :: Stream<Number>, thresh :: Number)-> Number:
  doc: ""
  ...
end

fun approximation(coefficients :: List<Number>) -> Number:
  doc: 'Consumes a list of continued fractions and returns an approximation'
  cases (List) coefficients.rest:
    | empty => coefficients.first 
    | link(f, r) =>
      coefficients.first + (1 / approximation(coefficients.rest))
  end
where:
  approximation(take(cf-e, 9)) is-roughly (1264 / 465)
end

fun fraction-helper(coefficients :: Stream<Number>, take-counter :: Number) -> Stream<Number>:
  next = take(coefficients, take-counter)
  lz-link(approximation(next), {(): fraction-helper(coefficients, take-counter + 1)})
end

fun fraction-stream(coefficients :: Stream<Number>) -> Stream<Number>:
  doc: "consumes a stream of coefficients and produces a corresponding stream of approximations"
  fraction-helper(coefficients, 1)
where:
  take(fraction-stream(repeating-stream([list: 1])), 3) is [list: 1, 2, 3/2]
  take(fraction-stream(cf-e), 4) is [list: 2, 3, 8/3, 11/4]
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
